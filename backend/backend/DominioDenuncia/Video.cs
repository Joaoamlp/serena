using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DominioDenuncia
{
    public class Video
    {
        public int Id { get; set; }

        public string Url { get; set; }
        public string NomeArquivo { get; set; }
        public string ContentType { get; set; }

        // Metadados importantes
        public long TamanhoBytes { get; set; }
        public int? Largura { get; set; }
        public int? Altura { get; set; }
        public double? DuracaoSegundos { get; set; }

        // Thumbnail opcional
        public string ThumbnailUrl { get; set; }

        public int DenunciaId { get; set; }
        public Denuncia Denuncia { get; set; }
    }
}
