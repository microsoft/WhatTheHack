using Microsoft.EntityFrameworkCore;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Server.Data
{
    public class ApplicationDbContext : DbContext
    {
        public DbSet<GameRecord> GameRecords { get; set; }
        public DbSet<BotRecord> BotRecords { get; set; }
        public DbSet<Competitor> Competitors { get; set; }

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }
    }
}
