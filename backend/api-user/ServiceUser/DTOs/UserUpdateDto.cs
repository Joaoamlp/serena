using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServiceUser
{
    public class UserUpdateDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Telefone { get; set; }
        public string EmailAddress { get; set; }
        public DateTime DataNascimento { get; set; }
        public EnderecoDto Endereco { get; set; }
        public List<ApoiosDto> Apoios { get; set; }
    }
}
