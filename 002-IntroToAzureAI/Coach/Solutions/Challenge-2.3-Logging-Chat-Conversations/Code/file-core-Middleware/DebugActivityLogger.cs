using System.Diagnostics;
using System.Threading.Tasks;
using Microsoft.Bot.Builder.History;
using Microsoft.Bot.Connector;
using System.IO;

namespace MiddlewareBot
{
    public class DebugActivityLogger : IActivityLogger
    {
        TextWriter tw;
        public DebugActivityLogger(TextWriter inputFile)
        {
            this.tw = inputFile;
        }

        public async Task LogAsync(IActivity activity)
        {
            Debug.WriteLine($"From:{activity.From.Id} - To:{activity.Recipient.Id} - Message:{activity.AsMessageActivity().Text}");
            tw.WriteLine($"From:{activity.From.Id} - To:{activity.Recipient.Id} - Message:{activity.AsMessageActivity().Text}", true);
            tw.Flush();
        }
    }
}
