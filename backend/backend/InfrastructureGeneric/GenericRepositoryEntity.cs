using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;


namespace InfrastructureGeneric
{
    public class GenericRepositoryEntity<T, Tcontext>: IGenericRepository<T> where T : class where Tcontext : DbContext
    {
        private readonly Tcontext _context; //contexto generico que pode ser qualquer contexto do EF
        private readonly DbSet<T> _dbSet; //tabela generica  que pode acessar outras tabelas

        public GenericRepositoryEntity(Tcontext context )
        {
            _context = context;
            _dbSet = _context.Set<T>();

        }

        public async Task<int> SaveChangesAsync()
        {
            return await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<T>> FindAllByForeignKeyAsync(
        string foreignKeyName,
        object foreignKeyValue)
        {
            // 1. O DbSet<T> já está disponível: _dbSet

            var entityType = typeof(T); // Usamos o tipo T diretamente

            // 2. Encontrar a Propriedade (Coluna FK) na Entidade T
            var propertyInfo = entityType.GetProperty(foreignKeyName, BindingFlags.Public | BindingFlags.Instance);

            if (propertyInfo == null)
            {
                throw new ArgumentException($"A propriedade (FK) '{foreignKeyName}' não existe na entidade '{entityType.Name}'.");
            }

            // 3. Construir a Expressão Lambda (e => e.FKId == FkValue)
            var parameter = Expression.Parameter(entityType, "e");
            var propertyAccess = Expression.Property(parameter, propertyInfo);

            var foreignKeyValueConverted = Convert.ChangeType(foreignKeyValue, propertyInfo.PropertyType);
            var constant = Expression.Constant(foreignKeyValueConverted, propertyInfo.PropertyType);

            var equality = Expression.Equal(propertyAccess, constant);

            // Criamos a expressão Lambda tipada: Expression<Func<T, bool>>
            var predicate = Expression.Lambda<Func<T, bool>>(equality, parameter);

            // 4. Aplicar a Expressão diretamente ao _dbSet tipado!
            return await _dbSet.Where(predicate).ToListAsync();
        }
        public Task AddAsync(T entity)
        {
            _dbSet.Add(entity);
            return Task.CompletedTask;
        }
        public async Task<T?> GetByIdAsync(int id)
        {
            return await _dbSet.FindAsync(id);
        }
        public async Task<IEnumerable<T?>> GetAllAsync()
        {
            return await _dbSet.ToListAsync();

        }
        public Task UpdateAsync(T entity)
        {
            _dbSet.Update(entity);
            return Task.CompletedTask;
        }
        public async Task DeleteAsync(int id)
        {
            var entity = await GetByIdAsync(id);
            if (entity == null)
            {
                throw new KeyNotFoundException($"Entidade com id {id} não encontrada.");
            }

            _dbSet.Remove(entity);
            await _context.SaveChangesAsync();
        }

        public async Task<IEnumerable<T>> GetByConditionAsync(Expression<Func<T, bool>> predicate)
        {
            // O filtro é aplicado diretamente no banco de dados (Queryable)
            return await _dbSet.Where(predicate).ToListAsync();
        }

        public async Task<T?> GetByIdWithIncludesAsync(int id, params Expression<Func<T, object>>[] includes)
        {
            IQueryable<T> query = _dbSet.AsQueryable();

            if (includes != null && includes.Length > 0)
            {
                foreach (var include in includes)
                    query = query.Include(include);
            }

            // Pressupõe que a PK é "Id" do tipo int.
            return await query.FirstOrDefaultAsync(e => EF.Property<int>(e, "Id") == id);
        }
    }
}
