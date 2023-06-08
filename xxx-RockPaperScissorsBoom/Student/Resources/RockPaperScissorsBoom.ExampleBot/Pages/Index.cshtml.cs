using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Newtonsoft.Json;
using RockPaperScissor.Core.Game;
using RockPaperScissor.Core.Game.Results;
using RockPaperScissor.Core.Model;

namespace RockPaperScissorsBoom.ExampleBot.Pages
{
    public class IndexModel : PageModel
    {
        public void OnGet()
        {
            string rawJson = JsonConvert.SerializeObject(new BotChoice { Decision = Decision.Rock });
            JsonData = rawJson;
        }
        public ActionResult OnPost()
        {
            string rawJson = JsonConvert.SerializeObject(new BotChoice { Decision = Decision.Rock });
            JsonData = rawJson;
            return Page();
        }
        //public IActionResult OnPost(PreviousDecisionResult result)
        //{
        //    string rawJson = JsonConvert.SerializeObject(new BotChoice { Decision = Decision.Rock });
        //    JsonData = rawJson;
        //    return Page();
        //}

        public string JsonData { get; set; }
    }
}