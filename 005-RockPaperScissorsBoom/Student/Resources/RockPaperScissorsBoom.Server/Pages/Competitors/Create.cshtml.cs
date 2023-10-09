using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Server.Pages.Competitors
{
    public class CreateModel : PageModel
    {
        private readonly RockPaperScissorsBoom.Server.Data.ApplicationDbContext _context;

        public CreateModel(RockPaperScissorsBoom.Server.Data.ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult OnGet()
        {
            return Page();
        }

        [BindProperty]
        public Competitor Competitor { get; set; } = default!;


        // To protect from overposting attacks, see https://aka.ms/RazorPagesCRUD
        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid || _context.Competitors == null || Competitor == null)
            {
                return Page();
            }

            _context.Competitors.Add(Competitor);
            await _context.SaveChangesAsync();

            return RedirectToPage("./Index");
        }
    }
}
