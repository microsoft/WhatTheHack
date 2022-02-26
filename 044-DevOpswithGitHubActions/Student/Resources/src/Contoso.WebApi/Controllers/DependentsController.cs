using Contoso.Data.Contexts;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace Contoso.WebApi.Controllers
{
    [Produces("application/json")]
    [Route("api/[controller]")]
    [ApiController]
    public class DependentsController : ControllerBase
    {
        private readonly ContosoDbContext _context;

        public DependentsController(ContosoDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var dependents = await _context.Dependents
                .AsNoTracking()
                .ToListAsync();

            return await Task.FromResult(new JsonResult(dependents));
        }

        [HttpGet("{id:int}")]
        public async Task<IActionResult> Get(int id)
        {
            var dependent = await _context.Dependents.FindAsync(id);

            if (dependent == null)
            {
                return new NotFoundObjectResult($"Dependent with Id {id} not found.");
            }

            return await Task.FromResult(new JsonResult(dependent));
        }
    }
}