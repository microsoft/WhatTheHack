using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Server.Pages.Competitors
{
    public class DeleteModel : PageModel
    {
        private readonly RockPaperScissorsBoom.Server.Data.ApplicationDbContext _context;

        public DeleteModel(RockPaperScissorsBoom.Server.Data.ApplicationDbContext context)
        {
            _context = context;
        }

        [BindProperty]
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

        public async Task<IActionResult> OnPostAsync(Guid? id)
        {
            if (id == null || _context.Competitors == null)
            {
                return NotFound();
            }
            var competitor = await _context.Competitors.FindAsync(id);

            if (competitor != null)
            {
                Competitor = competitor;
                _context.Competitors.Remove(Competitor);
                await _context.SaveChangesAsync();
            }

            return RedirectToPage("./Index");
        }
    }
}
