namespace BuildYourOwnCopilot.Infrastructure.Models.ConfigurationOptions
{
    public record SystemCommandPluginSettings
    {
        public required string Name { get; init; }
        public required string Description { get; init; }
        public string? PromptName { get; init; }
    }
}
