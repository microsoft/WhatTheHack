using Microsoft.SemanticKernel;

namespace BuildYourOwnCopilot.SemanticKernel.Plugins.Core
{
    /// <summary>
    /// AdvancedChatPlugin provides the capability to build the context for chat completions by recalling object information from the long term memory using vector-based similarity.
    /// Optionally, a short-term, volatile memory can be also used to enhance the result set.
    /// </summary>
    public sealed class ContextPluginsListPlugin
    {
        private readonly List<PluginBase> _contextPlugins;

        /// <summary>
        /// Creates a new instance of the AdvancedChatPlugin
        /// </summary>
        public ContextPluginsListPlugin(
            List<PluginBase> contextPlugins)
        {
            _contextPlugins = contextPlugins;
        }

        /// <summary>
        /// Creates a list of names and descriptions of memory store context plugins.
        /// </summary>
        [KernelFunction(name: "ListContextPlugins")]
        public async Task<string> ListContextPluginsAsync()
        {
            var contextPluginsList = string.Join(Environment.NewLine,
                _contextPlugins.Select(p =>
                    $"{Environment.NewLine}Name: {p.Name}{Environment.NewLine}Description: {p.Description}{Environment.NewLine}"));

            return await Task.FromResult<string>(contextPluginsList);
        }
    }
}
