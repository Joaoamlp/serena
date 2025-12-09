using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DominioUser
{
    public class User
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }
        public string Name { get; set; }

        public string Email { get; set; }
        public string PasswordHash { get; set; }    
        public string Cpf { get; set; }
        public string Rg { get; set; }
        public string Telefone { get; set; }

        public DateTime DataNascimento { get; set; }

        public Endereco Endereco { get; set; }
        public ICollection<Apoios> NumerosDeApoio { get; set; }

    }
}
