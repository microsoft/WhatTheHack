namespace BuildYourOwnCopilot.Common.Models.BusinessDomain
{
    [AttributeUsage(AttributeTargets.Property | AttributeTargets.Field, AllowMultiple = false, Inherited = true)]
    public class EmbeddingFieldAttribute : Attribute
    {
        public string Label { get; set; }
    }
}
