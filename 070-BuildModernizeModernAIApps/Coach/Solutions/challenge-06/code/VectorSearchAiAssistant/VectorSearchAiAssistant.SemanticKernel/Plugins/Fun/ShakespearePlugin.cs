using Microsoft.SemanticKernel.Connectors.AI.OpenAI;
using Microsoft.SemanticKernel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VectorSearchAiAssistant.SemanticKernel.Plugins.Fun
{
    public class ShakespearePlugin
    {
        private readonly ISKFunction _shakespeare;
        private readonly IKernel _kernel;

        public ShakespearePlugin(
            IKernel kernel)
        {
            _kernel = kernel;
            _shakespeare = kernel.CreateSemanticFunction(
"""
{{$input}}

Rewrite the above as a poem in the style of Shakespeare.
""",
                pluginName: nameof(ShakespearePlugin),
                description: "Produces text in the style of Shakespeare.",
                requestSettings: new OpenAIRequestSettings
                {
                    MaxTokens = 2000,
                    Temperature = 0.1,
                    TopP = 0.5
                });
        }
    }
}
