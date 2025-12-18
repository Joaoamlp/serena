using AutoMapper;
using DominioDenuncia;
using InfrastructureGeneric;
using Microsoft.EntityFrameworkCore;
using DominioDenuncia;

namespace ServiceDenuncia
{
    public class DenunciaService : IDenunciaService
    {
        private readonly IGenericRepository<Denuncia> _denunciaRepository;
        private readonly IMapper _mapper;
        private readonly IUserApiClient _userClient;

        public DenunciaService(
            IGenericRepository<Denuncia> denunciaRepo,
            IMapper mapper,
            IUserApiClient userClient)
        {
            _denunciaRepository = denunciaRepo;
            _mapper = mapper;
            _userClient = userClient;
        }

        public async Task<DenunciaDto> CreatDenunciaAsync(DenunciaCreateDto dto)
        {
            if (dto == null)
                throw new ArgumentNullException(nameof(dto));

            // 🔒 UsuarioId é obrigatório
            if (dto.UsuarioId <= 0)
                throw new ApplicationException("UsuarioId é obrigatório para criar uma denúncia.");

            // 🔎 valida usuário no serviço externo
            
            try
            {
                var resp = await _userClient.UserExistsAsync(dto.UsuarioId.Value);
                if (resp == null)
                    throw new ApplicationException("Usuário não encontrado no serviço externo.");
                _mapper.Map(resp, dto);

            }
            catch (TimeoutException)
            {
                throw new ApplicationException("Timeout ao verificar usuário.");
            }
            catch (Exception)
            {
                throw new ApplicationException("Erro ao verificar usuário no serviço externo.");
            }

     

            try
            {
                
                var entity = _mapper.Map<Denuncia>(dto);
                
                entity.CriadoEm = DateTime.UtcNow;
                entity.Status = DenunciaStatus.Nova;

                await _denunciaRepository.AddAsync(entity);
                await _denunciaRepository.SaveChangesAsync();

                return _mapper.Map<DenunciaDto>(entity);
            }
            catch (DbUpdateException ex)
            {
                throw new ApplicationException("Erro ao salvar denúncia no banco.", ex);
            }
            catch (AutoMapperMappingException ex)
            {
                throw new ApplicationException("Erro ao mapear dados da denúncia.", ex);
            }
        }

        public async Task<IEnumerable<DenunciaDto>> GetAllDenunciasAsync(int userId)
        {
            if (userId <= 0)
                throw new ArgumentException("UsuarioId inválido.");

            var list = await _denunciaRepository
                .FindAllByForeignKeyAsync("UsuarioId", userId);
                

            return _mapper.Map<IEnumerable<DenunciaDto>>(list);
        }

        public async Task<DenunciaDto?> GetDenunciaByIdAsync(int id)
        {
            if (id <= 0)
                throw new ArgumentException("Id inválido.");

            var entity = await _denunciaRepository.GetByIdWithIncludesAsync(id,e=> e.Endereco);
            return entity == null ? null : _mapper.Map<DenunciaDto>(entity);
        }

        public async void UpdateByIdUser(int id)
        {
            if (id <= 0)
                throw new ArgumentException("Id inválido.");
            try
            {


                var lista = GetAllDenunciasAsync(id);

                foreach (var dto in lista.Result)
                {
                    Denuncia denuncia = _mapper.Map<Denuncia>(dto);
                    denuncia.Status = DenunciaStatus.EmAnalise;
                    denuncia.UsuarioId = null;
                    _denunciaRepository.UpdateAsync(denuncia);

                }
                _denunciaRepository.SaveChangesAsync();
                
            }
            catch (DbUpdateException ex)
            {
                throw new ApplicationException("Erro ao atualizar denúncias no banco.", ex);
            }
        }
    }
}

