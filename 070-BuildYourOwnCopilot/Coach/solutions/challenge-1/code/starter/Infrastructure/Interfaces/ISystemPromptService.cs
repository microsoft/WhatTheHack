using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BuildYourOwnCopilot.Infrastructure.Interfaces
{
    public interface ISystemPromptService
    {
        Task<string> GetPrompt(string promptName, bool forceRefresh = false);
    }
}
