using RockPaperScissorsBoom.Core.Game;

namespace RockPaperScissorsBoom.Core.Model
{
    public class BotChoice
    {
        public Decision Decision { get; set; }

        public BotChoice(Decision decision)
        {
            Decision = decision;
        }
    }
}