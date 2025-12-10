using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DominioDenuncia
{
    public class Imagen
    {
        public int Id { get; set; }
        public string Url { get; set; }
        public string NomeArquivo { get; set; }
        public string ContentType { get; set; }
        public long TamanhoBytes { get; set; }
        public int? Largura { get; set; }
        public int? Altura { get; set; }
        public string StoragePath { get; set; }
        public DateTime UploadedAt { get; set; }

        // Chave estrangeira
        public int DenunciaId { get; set; }
        public Denuncia Denuncia { get; set; }
    }
}
