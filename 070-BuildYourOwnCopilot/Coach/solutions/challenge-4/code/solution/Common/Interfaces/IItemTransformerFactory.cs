namespace BuildYourOwnCopilot.Common.Interfaces
{
    public interface IItemTransformerFactory
    {
        IItemTransformer CreateItemTransformer(dynamic item);
    }
}
