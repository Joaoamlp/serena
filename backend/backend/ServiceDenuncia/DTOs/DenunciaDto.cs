using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServiceDenuncia.DTOs
{
    public class DenunciaDto
    {
        public int Id { get; set; }
        public string Titulo { get; set; }
        public string Descricao { get; set; }
        public int? UsuarioId { get; set; }
        public string EmailContato { get; set; }
        public string TelefoneContato { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public bool Sensitive { get; set; }
        public string Status { get; set; }
        public DateTime CriadoEm { get; set; }
        public DateTime? AtualizadoEm { get; set; }

        public IList<DenunciaMediaDto> Imagens { get; set; } = new List<DenunciaMediaDto>();
        public IList<DenunciaMediaDto> Videos { get; set; } = new List<DenunciaMediaDto>();
    }
}
