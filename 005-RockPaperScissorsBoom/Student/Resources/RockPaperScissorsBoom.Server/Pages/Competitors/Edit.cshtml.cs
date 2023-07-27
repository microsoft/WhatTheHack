using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Server.Pages.Competitors
{
    public class EditModel : PageModel
    {
        private readonly RockPaperScissorsBoom.Server.Data.ApplicationDbContext _context;

        public EditModel(RockPaperScissorsBoom.Server.Data.ApplicationDbContext context)
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
            Competitor = competitor;
            return Page();
        }

        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see https://aka.ms/RazorPagesCRUD.
        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            _context.Attach(Competitor).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CompetitorExists(Competitor.Id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return RedirectToPage("./Index");
        }

        private bool CompetitorExists(Guid id)
        {
            return (_context.Competitors?.Any(e => e.Id == id)).GetValueOrDefault();
        }
    }
}
