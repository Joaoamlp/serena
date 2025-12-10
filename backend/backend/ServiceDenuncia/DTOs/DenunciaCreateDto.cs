using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServiceDenuncia
{
    public class DenunciaCreateDto
    {
        public string Titulo { get; set; }
        public string Descricao { get; set; }
        public int? UsuarioId { get; set; }
        public string EmailContato { get; set; }
        public string TelefoneContato { get; set; }
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public bool Sensitive { get; set; } = false;
    }
}
