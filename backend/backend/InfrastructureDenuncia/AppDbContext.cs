using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using DominioDenuncia; // namespace das entidades

namespace InfrastructureDenuncia
{
    public class AppDbContext: DbContext
    {
        // O construtor recebe opções (ex.: string de conexão, provedor, lazy loading, etc).
        // Essas opções são configuradas no Program.cs ou Startup.cs.
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {

        }
        // DbSet representa uma coleção de todas as entidades no contexto, ou que podem ser consultadas do banco.
        public DbSet<Denuncia> Denuncias { get; set; }
        public DbSet<Imagen> Imagens { get; set; }
        public DbSet<Video> Vidios { get; set; }
        // aqui fazemos a configuração do banco, como  sua estrutura.
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
        }
    }
}
