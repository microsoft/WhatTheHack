using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Server.Pages.Competitors
{
    public class DetailsModel : PageModel
    {
        private readonly RockPaperScissorsBoom.Server.Data.ApplicationDbContext _context;

        public DetailsModel(RockPaperScissorsBoom.Server.Data.ApplicationDbContext context)
        {
            _context = context;
        }

        public Competitor Competitor { get; set; } = default!;

        public async Task<IActionResult> OnGetAsync(Guid? id)
        {
            if (id == null || _context.Competitors == null)
            {
                return NotFound();
            }

            var competitor = await _context.Competitors.FirstOrDefaultAsync(m => m.Id == id);
            if (competitor == null)
            {
                return NotFound();
            }
            else
            {
                Competitor = competitor;
            }
            return Page();
        }
    }
}
