using Microsoft.SemanticKernel;

#pragma warning disable SKEXP0001

namespace BuildYourOwnCopilot.Infrastructure.Services
{
    public class DefaultPromptFilter : IPromptRenderFilter
    {
        public string RenderedPrompt => _renderedPrompt;

        public string PluginName => _pluginName;

        public string FunctionName => _functionName;

        private string _renderedPrompt = string.Empty;
        private string _pluginName = string.Empty;
        private string _functionName = string.Empty;

        public async Task OnPromptRenderAsync(PromptRenderContext context, Func<PromptRenderContext, Task> next)
        {
            _pluginName = context.Function?.PluginName ?? string.Empty;
            _functionName = context.Function?.Name ?? string.Empty;

            await next(context);

            _renderedPrompt = context.RenderedPrompt ?? string.Empty;
        }
    }
}
