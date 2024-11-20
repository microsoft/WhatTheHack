using Microsoft.DeepDev;

namespace BuildYourOwnCopilot.Infrastructure.Services.Text
{
    /// <summary>
    /// Extends the <see cref="TikTokenizer"/> class to support leasing to multiple clients.
    /// </summary>
    public class LeasedTikTokenizer(
        Stream tikTokenBpeFileStream,
        IReadOnlyDictionary<string, int> specialTokensEncoder,
        string pattern,
        int cacheSize) : TikTokenizer(tikTokenBpeFileStream, specialTokensEncoder, pattern, cacheSize)
    {
        /// <summary>
        /// Indicates whether the tokenizer is leased or not.
        /// </summary>
        public bool IsLeased { get; set; }
    }
}
