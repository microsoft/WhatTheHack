using Contoso.Data.Entities;
using Microsoft.EntityFrameworkCore;
namespace Contoso.Data.Contexts
{
    public class ContosoDbContext: DbContext
    {
        public ContosoDbContext(DbContextOptions<ContosoDbContext> options): base(options)
        {
        }

        // Entities
        public DbSet<Dependent> Dependents { get; set; }
        public DbSet<Person> People { get; set; }
        public DbSet<Policy> Policies { get; set; }
        public DbSet<PolicyHolder> PolicyHolders { get; set; }
    }
}