using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DominioUser
{
    public class User
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        public string Name { get; set; }

        [Required]
        public string Email { get; set; }

        [Required]
        public string PasswordHash { get; set; }    

        [Required]
        public string Cpf { get; set; }

        public string? Rg { get; set; } // Agora opcional
        public string? Telefone { get; set; } // Pode ficar vazio

        public DateTime? DataNascimento { get; set; } // Opcional

        public Endereco? Endereco { get; set; } // Opcional
        public ICollection<Apoios>? NumerosDeApoio { get; set; } // Opcional
    }
}
