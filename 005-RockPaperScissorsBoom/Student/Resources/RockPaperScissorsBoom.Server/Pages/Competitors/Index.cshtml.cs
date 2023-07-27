using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Server.Pages.Competitors
{
    public class IndexModel : PageModel
    {
        private readonly RockPaperScissorsBoom.Server.Data.ApplicationDbContext _context;

        public IndexModel(RockPaperScissorsBoom.Server.Data.ApplicationDbContext context)
        {
            _context = context;
        }

        public IList<Competitor> Competitor { get; set; } = default!;

        public async Task OnGetAsync()
        {
            if (_context.Competitors != null)
            {
                Competitor = await _context.Competitors.ToListAsync();
            }
        }
    }
}
