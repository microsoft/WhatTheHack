using Azure.Search.Documents.Indexes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;
using VectorSearchAiAssistant.SemanticKernel.Models;
using VectorSearchAiAssistant.SemanticKernel.TextEmbedding;

namespace VectorSearchAiAssistant.Service.Models.Search
{
    public class Campaign : EmbeddedEntity
    {
        [SearchableField(IsFilterable = true)]
        public string campaignId { get; set; }

        [SimpleField]
        [EmbeddingField(Label = "Campaign name")]
        public string campaignName { get; set; }
        [SimpleField]
        [EmbeddingField(Label = "Campaign description")]
        public string campaignDescription { get; set; }
    }
}
