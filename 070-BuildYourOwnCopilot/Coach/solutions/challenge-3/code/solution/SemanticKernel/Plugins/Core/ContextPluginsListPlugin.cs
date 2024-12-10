using Microsoft.SemanticKernel;

namespace BuildYourOwnCopilot.SemanticKernel.Plugins.Core
{
    /// <summary>
    /// Provides the capability to build the list of available plugins.
    /// </summary>
    public sealed class ContextPluginsListPlugin
    {
        private readonly List<PluginBase> _contextPlugins;

        /// <summary>
        /// Creates a new instance of the ContextPluginsListPlugin.
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
