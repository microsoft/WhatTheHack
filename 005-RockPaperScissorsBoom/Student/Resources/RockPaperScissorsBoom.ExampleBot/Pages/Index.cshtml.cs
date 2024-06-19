using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using RockPaperScissorsBoom.Core.Game;
using RockPaperScissorsBoom.Core.Model;
using System.Text.Json;

namespace RockPaperScissorsBoom.ExampleBot.Pages
{
    public class IndexModel : PageModel
    {
        public string JsonData { get; set; } = "";

        public IndexModel()
        {
        }
        public void OnGet()
        {
            string rawJson = JsonSerializer.Serialize(new BotChoice(Decision.Rock));
            JsonData = rawJson;
        }
        public ActionResult OnPost()
        {
            string rawJson = JsonSerializer.Serialize(new BotChoice(Decision.Rock));
            JsonData = rawJson;
            return Page();
        }
    }
}