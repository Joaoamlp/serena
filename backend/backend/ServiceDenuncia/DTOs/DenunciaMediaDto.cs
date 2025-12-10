using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServiceDenuncia.DTOs
{
    public class DenunciaMediaDto
    {
        public int Id { get; set; }
        public string Url { get; set; }
        public string NomeArquivo { get; set; }
        public string ContentType { get; set; }
        public long TamanhoBytes { get; set; }
        public int? Largura { get; set; }
        public int? Altura { get; set; }
        public double? DuracaoSegundos { get; set; }
        public string ThumbnailUrl { get; set; }
    }
}
