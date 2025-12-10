namespace DominioDenuncia
{
    public class Denuncia
    {
        public int Id { get; set; }

        // Informação básica
        public string Titulo { get; set; }
        public string Descricao { get; set; }

        // Denúncia pode ser anônima — UserId opcional
        public int? UsuarioId { get; set; }

        // Contatos opcionais
        public string EmailContato { get; set; }
        public string TelefoneContato { get; set; }

        // Localização opcional
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }

        // Conteúdo sensível
        public bool Sensitive { get; set; } = false;

        // Status da denúncia
        public DenunciaStatus Status { get; set; } = DenunciaStatus.Nova;

        // Datas
        public DateTime CriadoEm { get; set; } = DateTime.UtcNow;
        public DateTime? AtualizadoEm { get; set; }

        // Relações com mídia
        public ICollection<Imagen> Imagens { get; set; }
        public ICollection<Video> Videos { get; set; }


    }
}
