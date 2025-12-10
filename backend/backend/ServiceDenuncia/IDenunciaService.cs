using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServiceDenuncia
{
    public interface IDenunciaService
    {
        Task<DenunciaDto> CreateAsync(DenunciaCreateDto dto, CancellationToken ct = default);
        Task<DenunciaDto> GetByIdAsync(int id, CancellationToken ct = default);
        Task<PagedResult<DenunciaDto>> GetPagedAsync(int page = 1, int pageSize = 20, CancellationToken ct = default);
        Task<bool> UpdateStatusAsync(int id, DenunciaStatusUpdateDto dto, CancellationToken ct = default);
        Task<bool> DeleteAsync(int id, CancellationToken ct = default);

        // Mídia
        Task<DenunciaMediaDto> AddImageAsync(int denunciaId, IFormFileWrapper file, CancellationToken ct = default);
        Task<DenunciaMediaDto> AddVideoAsync(int denunciaId, IFormFileWrapper file, CancellationToken ct = default);
    }
}
