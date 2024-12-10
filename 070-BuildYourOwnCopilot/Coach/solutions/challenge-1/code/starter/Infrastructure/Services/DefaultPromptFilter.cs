using Microsoft.SemanticKernel;

#pragma warning disable SKEXP0001

namespace BuildYourOwnCopilot.Infrastructure.Services
{
    public class DefaultPromptFilter : IPromptRenderFilter
    {
        //--------------------------------------------------------------------------------------------------------
        // TODO: [Challenge 2][Exercise 2.2.1] Define public properties to expose the intercepted values.
        //--------------------------------------------------------------------------------------------------------

        public async Task OnPromptRenderAsync(PromptRenderContext context, Func<PromptRenderContext, Task> next)
        {
            //--------------------------------------------------------------------------------------------------------
            // TODO: [Challenge 2][Exercise 2.2.2] Implement the handler to intercept prompt rendering values.
            //--------------------------------------------------------------------------------------------------------
            await Task.CompletedTask;
        }
    }
}
