using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BuildYourOwnCopilot.SemanticKernel.Chat
{
    public interface ITokenizer
    {
        int GetTokensCount(string text);
    }
}
