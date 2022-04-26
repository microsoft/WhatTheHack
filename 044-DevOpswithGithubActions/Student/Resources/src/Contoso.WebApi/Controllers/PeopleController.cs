using Contoso.Data.Contexts;
using Contoso.Data.Entities;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace Contoso.WebApi.Controllers
{
    [Produces("application/json")]
    [Route("api/[controller]")]
    [ApiController]
    public class PeopleController : ControllerBase
    {
        private readonly ContosoDbContext _context;

        public PeopleController(ContosoDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var people = await _context.People
                .AsNoTracking()
                .ToListAsync();

            return await Task.FromResult(new JsonResult(people));
        }

        [HttpGet("{id:int}")]
        public async Task<IActionResult> Get(int id)
        {
            var person = await _context.People.FindAsync(id);

            if (person == null)
            {
                return new NotFoundObjectResult($"Person with Id {id} not found.");
            }

            return await Task.FromResult(new JsonResult(person));
        }

        [HttpDelete("{id:int}")]
        public async Task<IActionResult> Delete(int id)
        {
            var person = await _context.People.FindAsync(id);

            if (person == null)
            {
                return new NotFoundObjectResult($"Person with Id {id} not found.");
            }

            _context.People.Remove(person);
            var result = await _context.SaveChangesAsync();
            var statusCode = result > 0 ? 200 : 500;
            return await Task.FromResult(new StatusCodeResult(statusCode));
        }

        [HttpPost]
        public async Task<IActionResult> Create(Person person)
        {
            var newPerson = _context.People.Add(person);
            await _context.SaveChangesAsync();
            return await Task.FromResult(new OkObjectResult($"Successfully created person {person.Id}."));
        }
    }
}