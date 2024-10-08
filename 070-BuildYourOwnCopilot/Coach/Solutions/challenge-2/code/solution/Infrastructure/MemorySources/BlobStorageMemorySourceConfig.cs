using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BuildYourOwnCopilot.Infrastructure.MemorySource
{
    public class BlobStorageMemorySourceConfig
    {
        public List<TextFileMemorySource> TextFileMemorySources { get; init; }
    }

    public class TextFileMemorySource
    {
        public string ContainerName { get; init; }
        public List<TextFileMemorySourceFile> TextFiles { get; init; }
    }

    public class TextFileMemorySourceFile
    {
        public string FileName { get; init; }
        public bool SplitIntoChunks { get; init; }
    }
}
