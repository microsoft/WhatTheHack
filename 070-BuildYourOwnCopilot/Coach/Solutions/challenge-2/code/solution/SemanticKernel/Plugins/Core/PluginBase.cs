using System.Runtime;

namespace BuildYourOwnCopilot.SemanticKernel.Plugins.Core
{
    public class PluginBase(
        string name,
        string description,
        string? promptName = null)
    {
        private readonly string _name = name;
        private readonly string _description = description;
        private readonly string? _promptName = promptName;

        public string Name => _name;

        public string Description => _description;

        public string? PromptName => _promptName;
    }
}
