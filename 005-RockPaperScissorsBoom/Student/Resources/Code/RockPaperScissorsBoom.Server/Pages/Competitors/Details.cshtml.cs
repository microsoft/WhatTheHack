using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using RockPaperScissor.Core.Model;
using RockPaperScissorsBoom.Server.Data;

namespace RockPaperScissorsBoom.Server.Pages.Competitors
{
    public class DetailsModel : PageModel
    {
        private readonly RockPaperScissorsBoom.Server.Data.ApplicationDbContext _context;

        public DetailsModel(RockPaperScissorsBoom.Server.Data.ApplicationDbContext context)
        {
            _context = context;
        }

        public Competitor Competitor { get; set; }

        public async Task<IActionResult> OnGetAsync(Guid? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            Competitor = await _context.Competitors.FirstOrDefaultAsync(m => m.Id == id);

            if (Competitor == null)
            {
                return NotFound();
            }
            return Page();
        }
    }
}
