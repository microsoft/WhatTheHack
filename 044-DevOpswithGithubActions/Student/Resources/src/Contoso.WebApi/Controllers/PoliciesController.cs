using Contoso.Data.Contexts;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace Contoso.WebApi.Controllers
{
    [Produces("application/json")]
    [Route("api/[controller]")]
    [ApiController]
    public class PoliciesController : ControllerBase
    {
        private readonly ContosoDbContext _context;

        public PoliciesController(ContosoDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var policies = await _context.Policies
                .AsNoTracking()
                .ToListAsync();

            return await Task.FromResult(new JsonResult(policies));
        }

        [HttpGet("{id:int}")]
        public async Task<IActionResult> Get(int id)
        {
            var policy = await _context.Policies.FindAsync(id);

            if (policy == null)
            {
                return new NotFoundObjectResult($"Policy with Id {id} not found.");
            }

            return await Task.FromResult(new JsonResult(policy));
        }
    }
}