using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VectorSearchAiAssistant.SemanticKernel.Models;
using VectorSearchAiAssistant.SemanticKernel.TextEmbedding;

namespace VectorSearchAiAssistant.Service.Models.Search
{
    public class ShortTermMemory : EmbeddedEntity
    {
        [EmbeddingField]
        public string memory__ { get; set; }
    }
}
