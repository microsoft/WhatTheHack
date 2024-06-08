using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VectorSearchAiAssistant.Service.MemorySource
{
    public class AzureCognitiveSearchMemorySourceConfig
    {
        public List<FacetedQueryMemorySource> FacetedQueryMemorySources { get; set; }
    }

    public class FacetedQueryMemorySource
    {
        public string Filter { get; init; }
        public List<FacetedQueryFacet> Facets { get; init; }
        public string TotalCountMemoryTemplate { get; init; }
    }

    public class FacetedQueryFacet
    {
        public string Facet { get; init; }
        public string CountMemoryTemplate { get; init; }
    }
}
