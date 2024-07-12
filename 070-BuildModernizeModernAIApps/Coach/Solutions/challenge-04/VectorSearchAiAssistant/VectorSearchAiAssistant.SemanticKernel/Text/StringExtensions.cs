using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Metadata.Ecma335;
using System.Text;
using System.Threading.Tasks;

namespace VectorSearchAiAssistant.SemanticKernel.Text
{
    public static class StringExtensions
    {
        public static string NormalizeLineEndings(this string src)
        {
            return src.ReplaceLineEndings("\n");
        }
    }
}
