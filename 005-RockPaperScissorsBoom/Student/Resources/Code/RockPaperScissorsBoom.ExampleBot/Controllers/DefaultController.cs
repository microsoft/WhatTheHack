using Microsoft.AspNetCore.Mvc;
using RockPaperScissor.Core.Game;
using RockPaperScissor.Core.Model;

namespace RockPaperScissorsBoom.ExampleBot.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DefaultController : ControllerBase
    {
        // GET: api/Default
        [HttpGet]
        public BotChoice Get()
        {
            return new BotChoice {Decision = Decision.Paper};
        }

        // POST: api/Default
        [HttpPost]
        //public BotChoice Post([FromBody] string value)
        public BotChoice Post()
        {
            return new BotChoice { Decision = Decision.Paper };
        }
    }
}
