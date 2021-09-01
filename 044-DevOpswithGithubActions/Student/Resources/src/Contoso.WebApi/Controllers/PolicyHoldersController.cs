using Contoso.Data.Contexts;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace Contoso.WebApi.Controllers
{
    [Produces("application/json")]
    [Route("api/[controller]")]
    [ApiController]
    public class PolicyHoldersController : ControllerBase
    {
        private readonly ContosoDbContext _context;

        public PolicyHoldersController(ContosoDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var policyHolders = await _context.PolicyHolders
                .Include(p => p.Person)
                .Include(p => p.Policy)
                .AsNoTracking()
                .ToListAsync();

            return await Task.FromResult(new JsonResult(policyHolders));
        }

        [HttpGet("{id:int}")]
        public async Task<IActionResult> Get(int id)
        {
            var policyHolder = await _context.PolicyHolders.Include(p => p.Person).Include(p => p.Policy).FirstOrDefaultAsync(p => p.Id == id);

            if (policyHolder == null)
            {
                return new NotFoundObjectResult($"PolicyHolder with Id {id} not found.");
            }

            return await Task.FromResult(new JsonResult(policyHolder));
        }
    }
}