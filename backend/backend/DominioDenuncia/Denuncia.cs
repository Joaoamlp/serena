namespace DominioDenuncia
{
    public class Denuncia
    {
        public int Id { get; set; }

        // Informação básica
        public string Descricao { get; set; }

        // Denúncia pode ser anônima — UserId opcional
        public int? UsuarioId { get; set; }

        public Endereco Endereco { get; set; }


        // Status da denúncia
        public DenunciaStatus Status { get; set; } = DenunciaStatus.Nova;
        public TipoViolencia TipoViolencia { get; set; }

        // Datas
        public DateTime CriadoEm { get; set; }
       

        


    }
}
