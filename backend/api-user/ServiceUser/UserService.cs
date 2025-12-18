using AutoMapper;
using DominioUser;
using InfrastructureUser;
using Microsoft.EntityFrameworkCore; // Importante para exceções do DB
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ServiceUser
{
    public class UserService : IUserService
    {
        private readonly IGenericRepository<User> _userRepository;
        private readonly IMapper _mapper;

        public UserService(IGenericRepository<User> userRepository, IMapper mapper)
        {
            _userRepository = userRepository;
            _mapper = mapper;
        }

        

        public async Task<UserReadDTO> AddUserAsync(UserCreateDto dto)
        {
            if (dto == null)
                throw new ArgumentNullException(nameof(dto));

            try
            {
                // 1. Validação de Regra de Negócio (Já tem tratamento interno)
                await VerifyUniqueFieldsAsync(dto.Email, dto.Cpf, dto.Rg);

                // 2. Mapeamento
                var user = _mapper.Map<User>(dto);
                user.PasswordHash = HashPassword(dto.Password);


                // 3. Persistência e Commit (Bloco Crítico)
                await _userRepository.AddAsync(user);
                await _userRepository.SaveChangesAsync();

                return _mapper.Map<UserReadDTO>(user);
            }
            // Captura erros de I/O ou conexão do Repositório
            catch (DbUpdateException ex)
            {
                // Exceção do EF Core (falha no SaveChanges)
                // Usamos o InnerException para obter detalhes da falha no banco (ex: violação de constraint)
                throw new InvalidOperationException(
                    $"Falha na persistência do usuário. Erro no banco de dados: {ex.InnerException?.Message ?? ex.Message}", ex);
            }
            catch (AutoMapperMappingException ex)
            {
                // Exceção de falha de mapeamento (se os tipos de DTO estiverem errados)
                throw new InvalidOperationException($"Erro ao mapear o objeto UserCreateDto para a entidade User. Detalhes: {ex.Message}", ex);
            }
            catch (Exception ex) when (ex is not ArgumentNullException && ex is not InvalidOperationException)
            {
                // Captura qualquer outra exceção inesperada e adiciona contexto
                throw new Exception($"Erro inesperado ao tentar adicionar o usuário. Por favor, verifique a infraestrutura.", ex);
            }
        }

        

        public async Task<UserReadDTO> UpdateUserAsync(int id, UserUpdateDto dto)
        {
            if (dto == null) throw new ArgumentNullException(nameof(dto));

            // Carrega o user com Endereco e Apoios
            var existing = await _userRepository.GetByIdWithIncludesAsync(id, u => u.Endereco, u => u.NumerosDeApoio);
            if (existing == null)
                throw new InvalidOperationException("Usuário não encontrado.");

            // Validações de unicidade (ex.: email) — ignore o próprio usuário
            await VerifyUniqueFieldsAsync(dto.Email, null, null, id);

            // Mapeia campos simples do DTO para a entidade (nome, telefone, etc.)
            _mapper.Map(dto, existing);

            // ======= 1:1 Endereco =======
            if (dto.Endereco == null)
            {
                // Se o dto não possui endereço, decide se quer remover o existente:
                // existing.Endereco = null; // se quiser apagar
            }
            else
            {
                if (existing.Endereco == null)
                {
                    // Nenhum endereço existente — criar novo e atribuir ao user
                    var novoEndereco = _mapper.Map<Endereco>(dto.Endereco);
                    // Garantir vínculo correto
                    novoEndereco.UserId = existing.Id;
                    novoEndereco.User = existing;
                    existing.Endereco = novoEndereco;
                }
                else
                {
                    // Já existe endereço — atualizar os campos do endereço existente (merge)
                    _mapper.Map(dto.Endereco, existing.Endereco);
                    // existing.Endereco.UserId deve permanecer como existing.Id
                    existing.Endereco.UserId = existing.Id;
                }
            }

            // ======= 1:N Apoios (sincronizar) =======
            var incomingApoios = dto.NumerosDeApoio ?? new List<ApoiosDto>();

            // IDs vindos do cliente (somente os >0 são updates)
            var incomingIds = incomingApoios.Where(a => a.Id != 0).Select(a => a.Id).ToHashSet();

            // Remove apoios que existem no DB mas não vieram no DTO
            var toRemove = existing.NumerosDeApoio.Where(a => !incomingIds.Contains(a.Id)).ToList();
            foreach (var rem in toRemove)
            {
                existing.NumerosDeApoio.Remove(rem);
            }

            // Atualiza existentes e adiciona novos
            foreach (var apoioDto in incomingApoios)
            {
                if (apoioDto.Id == 0)
                {
                    // Novo apoio
                    var novo = _mapper.Map<Apoios>(apoioDto);
                    novo.User = existing;
                    novo.UserId = existing.Id;
                    existing.NumerosDeApoio.Add(novo);
                }
                else
                {
                    var atual = existing.NumerosDeApoio.FirstOrDefault(a => a.Id == apoioDto.Id);
                    if (atual != null)
                    {
                        _mapper.Map(apoioDto, atual);
                    }
                    else
                    {
                        // Caso cliente enviou ID que não existe — opcional: criar ou ignorar
                        // aqui vamos ignorar ou lançar
                        throw new InvalidOperationException($"Apoio com Id {apoioDto.Id} não encontrado para o usuário.");
                    }
                }
            }

            // Persistir alterações (presuma que UpdateAsync salva apenas marca para update)
            await _userRepository.UpdateAsync(existing);
            await _userRepository.SaveChangesAsync();

            return _mapper.Map<UserReadDTO>(existing);
        }
        

        public async Task<UserReadDTO> DeleteUserAsync(int id)
        {
            var user = await _userRepository.GetByIdAsync(id);

            if (user == null)
                throw new InvalidOperationException($"Usuário com ID {id} não encontrado para exclusão.");

            var userReadDto = _mapper.Map<UserReadDTO>(user); // Mapeia antes de deletar

            try
            {
                await _userRepository.DeleteAsync(id);
                await _userRepository.SaveChangesAsync();

                return userReadDto; // Retorna o objeto deletado para confirmação
            }
            catch (DbUpdateException ex) when (ex.InnerException?.Message.Contains("REFERENCE constraint") == true)
            {
                // Exemplo: Captura violação de chave estrangeira (FK)
                throw new InvalidOperationException(
                    $"Não foi possível excluir o usuário ID {id} pois ele possui registros associados (ex: Endereços).", ex);
            }
            catch (DbUpdateException ex)
            {
                throw new InvalidOperationException(
                    $"Falha ao excluir o usuário ID {id} no banco de dados. Detalhes: {ex.InnerException?.Message ?? ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"Erro inesperado ao excluir o usuário ID {id}.", ex);
            }
        }

        

        public async Task<UserReadDTO?> GetUserByIdAsync(int id)
        {
            try
            {
                var user = await _userRepository.GetByIdWithIncludesAsync(
                    id,
                    u => u.Endereco,
                    u => u.NumerosDeApoio);

                return user == null ? null : _mapper.Map<UserReadDTO>(user);
            }
            catch (Exception ex)
            {
                throw new Exception($"Erro ao buscar o usuário ID {id}. Verifique a conexão com o banco.", ex);
            }
        }

        

        private async Task VerifyUniqueFieldsAsync(string email, string cpf, string rg, int? ignoreId = null)
        {
            try
            {
                var existingEmail = await _userRepository.GetByConditionAsync(u =>

                    u.Email == email && (ignoreId == null || u.Id != ignoreId));
                
                if (existingEmail.Any())

                    throw new InvalidOperationException("Já existe um usuário com este email.");

                var existingCpf = await _userRepository.GetByConditionAsync(u =>

                    u.Cpf == cpf && (ignoreId == null || u.Id != ignoreId));

                if (existingCpf.Any())

                    throw new InvalidOperationException("Já existe um usuário com este CPF.");



                var existingRg = await _userRepository.GetByConditionAsync(u =>

                    u.Rg == rg && (ignoreId == null || u.Id != ignoreId));

                if (existingRg.Any())

                    throw new InvalidOperationException("Já existe um usuário com este RG.");
                
            }
            catch (Exception ex)
            {
                // Exceção de infraestrutura durante a busca por unicidade
                throw new Exception($"Erro de infraestrutura ao verificar a unicidade dos campos.", ex);
            }
        }

       
        private string HashPassword(string password)
        {
            // Substitua por BCrypt, PBKDF2 ou outra biblioteca segura na vida real!
            return Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(password));
        }

        // NOVO: Método de verificação de senha (usado para login)
        // Na vida real, usaria PasswordHasher.VerifyHashedPassword
        private bool VerifyPassword(string providedPassword, string storedHash)
        {
            string providedHash = HashPassword(providedPassword);
            return providedHash == storedHash;
        }

        public async Task<UserReadDTO?> AuthenticateAsync(string email, string password)
        {
            try
            {
                // 1. Busca o usuário pelo email
                var users = await _userRepository.GetByConditionAsync(u => u.Email == email);
                var user = users.FirstOrDefault();

                if (user == null)
                {
                    // Não lança exceção para não dar dica ao atacante, apenas retorna null
                    return null;
                }

                // 2. Verifica a senha (comparando o hash)
                if (!VerifyPassword(password, user.PasswordHash))
                {
                    return null; // Senha incorreta
                }

                // 3. Sucesso
                return _mapper.Map<UserReadDTO>(user);
            }
            catch (Exception ex)
            {
                throw new Exception($"Erro de infraestrutura durante a autenticação do usuário {email}.", ex);
            }
        }

        public async Task<UserReadDTO> ResetPasswordAsync(string email, string novaSenha)
        {
            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(novaSenha))
            {
                throw new ArgumentNullException("Email e Nova Senha são obrigatórios para redefinição.");
            }

            try
            {
                // 1. Buscar o usuário pelo e-mail
                // O GetByConditionAsync retorna IEnumerable<User>, pegamos o primeiro.
                var users = await _userRepository.GetByConditionAsync(u => u.Email == email);
                var user = users.FirstOrDefault();

                if (user == null)
                {
                    // Na redefinição de senha, é boa prática de segurança não confirmar
                    // que o e-mail não existe, mas lançar um erro genérico (como se o e-mail tivesse sido enviado).
                    // No entanto, para fins de debug, lançamos um erro claro:
                    throw new InvalidOperationException($"Usuário com e-mail '{email}' não encontrado.");
                }

                // 2. Hash da nova senha para comparação e salvamento
                string novoHash = HashPassword(novaSenha);

                // 3. Validação de Regra de Negócio: Nova senha deve ser diferente da atual
                if (novoHash == user.PasswordHash)
                {
                    throw new InvalidOperationException("A nova senha não pode ser igual à senha atual.");
                }

                // 4. Aplica a nova senha (hash)
                user.PasswordHash = novoHash;

                // 5. Persistência e Commit
                await _userRepository.UpdateAsync(user);
                await _userRepository.SaveChangesAsync();

                return _mapper.Map<UserReadDTO>(user);
            }
            catch (DbUpdateException ex)
            {
                // Falha no SaveChanges.
                throw new InvalidOperationException(
                    $"Falha na persistência ao redefinir a senha do usuário {email}. Erro no banco: {ex.InnerException?.Message ?? ex.Message}", ex);
            }
            catch (InvalidOperationException)
            {
                // Lança exceções de negócio (usuário não encontrado ou senha igual)
                throw;
            }
            catch (Exception ex)
            {
                // Captura qualquer outro erro inesperado e adiciona contexto
                throw new Exception($"Erro inesperado ao redefinir a senha para o e-mail {email}.", ex);
            }
        }

    }
}

