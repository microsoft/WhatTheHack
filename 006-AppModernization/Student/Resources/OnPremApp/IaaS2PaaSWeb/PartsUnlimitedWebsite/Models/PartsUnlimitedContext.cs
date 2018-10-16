using System.Data.Entity;
using Microsoft.AspNet.Identity.EntityFramework;

namespace PartsUnlimited.Models
{
    public class PartsUnlimitedContext : IdentityDbContext<ApplicationUser>, IPartsUnlimitedContext
    {
        public PartsUnlimitedContext() : base("name=DefaultConnectionString")
        {
            this.Configuration.LazyLoadingEnabled = false;
        }

        public IDbSet<Product> Products { get; set; }
        public IDbSet<Order> Orders { get; set; }
        public IDbSet<Category> Categories { get; set; }
        public IDbSet<CartItem> CartItems { get; set; }
        public IDbSet<OrderDetail> OrderDetails { get; set; }
        public IDbSet<Raincheck> RainChecks { get; set; }
        public IDbSet<Store> Stores { get; set; }
        
        protected override void OnModelCreating(DbModelBuilder builder)
        {
            builder.Entity<Product>().HasKey(a => a.ProductId);
            builder.Entity<Order>().HasKey(o => o.OrderId);
            builder.Entity<Category>().HasKey(g => g.CategoryId);
            builder.Entity<CartItem>().HasKey(c => c.CartItemId);
            builder.Entity<OrderDetail>().HasKey(o => o.OrderDetailId);
            builder.Entity<Raincheck>().HasKey(o => o.RaincheckId);
            builder.Entity<Store>().HasKey(o => o.StoreId);

            base.OnModelCreating(builder);
        }
    }
}
