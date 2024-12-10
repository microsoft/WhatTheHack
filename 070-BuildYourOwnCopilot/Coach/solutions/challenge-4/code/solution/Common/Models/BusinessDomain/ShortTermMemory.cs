namespace BuildYourOwnCopilot.Common.Models.BusinessDomain
{
    public class ShortTermMemory : EmbeddedEntity
    {
        [EmbeddingField]
        public string memory__ { get; set; }
    }
}
