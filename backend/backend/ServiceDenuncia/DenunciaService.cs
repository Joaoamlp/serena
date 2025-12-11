using AutoMapper;
using DominioDenuncia;
using InfrastructureGeneric;
using Microsoft.EntityFrameworkCore;

namespace ServiceDenuncia
{
    public class DenunciaService: IDenunciaService
    {
        private readonly IGenericRepository<Denuncia> DenunciaRepository;
        private readonly IMapper _mapper;
        private readonly IUserApiClient _userClient;
        public DenunciaService(IGenericRepository<Denuncia> denunciaRepo, IMapper mapa, IUserApiClient userClient)
        {
            _mapper = mapa;
            DenunciaRepository = denunciaRepo;
            _userClient = userClient;
        }

        public async Task<DenunciaDto> CreatDenunciaAsync(DenunciaCreateDto dto)
        {
            Console.WriteLine($"como a mensagem chega:{dto}");
            if (dto == null)
                throw new ArgumentNullException(nameof(dto), "O objeto DenunciaCreateDto não pode ser nulo.");
            if (dto.UsuarioId.HasValue)
            {
                bool exists;
                try
                {
                    exists = await _userClient.UserExistsAsync(dto.UsuarioId.Value);
                }
                catch (TimeoutException)
                {
                    // Decida política: bloquear criação (rejeitar) ou aceitar e validar depois.
                    // Aqui optamos por rejeitar com erro explícito.
                    throw new ApplicationException("Não foi possível verificar o usuário (timeout). Tente novamente.");
                }
                catch (ApplicationException)
                {
                    throw new ApplicationException("Erro ao verificar usuário em serviço externo.");
                }

                if (!exists)
                    throw new KeyNotFoundException($"Usuário com id {dto.UsuarioId.Value} não encontrado.");
            }

            try
            {
                var entity = _mapper.Map<Denuncia>(dto);

                await DenunciaRepository.AddAsync(entity);
                await DenunciaRepository.SaveChangesAsync();

                return _mapper.Map<DenunciaDto>(entity);
            }
            catch (DbUpdateException ex)
            {
                // Erros de banco
                throw new ApplicationException("Erro ao salvar denúncia no banco de dados.", ex);
            }
            catch (AutoMapperMappingException ex)
            {
                // Problemas de mapeamento
                throw new ApplicationException("Erro ao mapear os dados da denúncia.", ex);
            }
            catch (Exception ex)
            {
                // Qualquer outro erro
                throw new ApplicationException("Erro inesperado ao criar denúncia.", ex);
            }
        }
        public async Task<IEnumerable<DenunciaDto?>> GetAllDenunciasAsync(int userId)
        {
            if (userId <= 0)
                throw new ArgumentException("O ID do usuário deve ser maior que zero.", nameof(userId));

            var list = await DenunciaRepository
                .FindAllByForeignKeyAsync("UserId", userId);
            var denuncias = _mapper.Map<IEnumerable<DenunciaDto>>(list);
            return denuncias;
        }
        public async Task<DenunciaDto?> GetDenunciaByIdAsync(int id)
        {
            if (id <= 0)
                throw new ArgumentException("O ID deve ser maior que zero.", nameof(id));

            var entity = await DenunciaRepository.GetByIdAsync(id);

            if (entity == null)
                return null;
            var denunciaDto = _mapper.Map<DenunciaDto>(entity);
            return denunciaDto;
        }

    }
}
