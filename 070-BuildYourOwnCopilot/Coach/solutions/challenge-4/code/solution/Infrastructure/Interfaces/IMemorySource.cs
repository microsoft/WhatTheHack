namespace BuildYourOwnCopilot.Infrastructure.Interfaces
{
    public interface IMemorySource
    {
        Task<List<string>> GetMemories();
    }
}
