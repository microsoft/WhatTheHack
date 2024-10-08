namespace BuildYourOwnCopilot.Common.Models.BusinessDomain
{
    public class EmbeddedEntity
    {
        public string id { get; set; }

        [EmbeddingField(Label = "Entity (object) type")]
        public string entityType__ { get; set; }    // Since this applies to all business entities,  use a name that is unlikely to cause collisions with other properties
    }
}
