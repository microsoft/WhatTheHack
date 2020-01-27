using InventoryService.Api.Models;
using JetBrains.Annotations;
using Microsoft.EntityFrameworkCore;

namespace InventoryService.Api.Database
{
    public class InventoryContext : DbContext
    {
        public InventoryContext(DbContextOptions options) : base(options)
        {
        }

        public DbSet<InventoryItem> Inventory { get; set; }
        public DbSet<SecretUser> SecretUsers { get; set; }
        public DbSet<Payroll> Payroll { get; set; }
    }
}