namespace BuildYourOwnCopilot.SemanticKernel.Plugins.Core
{
    /// <summary>
    /// Provides the capability to identify a request to execute a system command.
    /// </summary>
    /// <param name="name">The name of the system command plugin.</param>
    /// <param name="description">The description of the system command plugin.</param>
    public class SystemCommandPlugin(
        string name,
        string description,
        string? promptName) : PluginBase(name, description, promptName)
    {
    }
}
