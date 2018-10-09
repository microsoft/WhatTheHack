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
    public class IndexModel : PageModel
    {
        private readonly RockPaperScissorsBoom.Server.Data.ApplicationDbContext _context;

        public IndexModel(RockPaperScissorsBoom.Server.Data.ApplicationDbContext context)
        {
            _context = context;
        }

        public IList<Competitor> Competitor { get;set; }

        public async Task OnGetAsync()
        {
            Competitor = await _context.Competitors.ToListAsync();
        }
    }
}
