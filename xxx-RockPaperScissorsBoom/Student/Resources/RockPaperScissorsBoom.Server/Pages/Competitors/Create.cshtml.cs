using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using RockPaperScissor.Core.Model;
using RockPaperScissorsBoom.Server.Data;

namespace RockPaperScissorsBoom.Server.Pages.Competitors
{
    [Authorize]
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
        public Competitor Competitor { get; set; }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            _context.Competitors.Add(Competitor);
            await _context.SaveChangesAsync();

            return RedirectToPage("./Index");
        }
    }
}