using BuildYourOwnCopilot.Common.Interfaces;

namespace BuildYourOwnCopilot.Common.Services
{
    public class ItemTransformerFactory : IItemTransformerFactory
    {
        public IItemTransformer CreateItemTransformer(dynamic item) =>
            new ModelRegistryItemTransformer(item);
    }
}
