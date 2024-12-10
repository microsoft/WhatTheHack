using BuildYourOwnCopilot.Infrastructure.Exceptions;

namespace BuildYourOwnCopilot.Infrastructure.Models.ConfigurationOptions
{
    /// <summary>
    /// Provides configuration settings that control token-based text splitting.
    /// </summary>
    public class TokenTextSplitterServiceSettings
    {
        /// <summary>
        /// The tokenizer used to split the test into tokens.
        /// </summary>
        public string? TokenizerEncoder { get; set; }

        /// <summary>
        /// The target size in tokens for the resulting text chunks.
        /// </summary>
        public int ChunkSizeTokens { get; set; }

        /// <summary>
        /// The target size in tokens for the overlapping parts of the adjacent text chunks.
        /// </summary>
        public int OverlapSizeTokens { get; set; }

        /// <summary>
        /// Creates and instance of the class based on a dictionary.
        /// </summary>
        /// <param name="settings">The dictionary containing the settings.</param>
        /// <returns>A <see cref="TokenTextSplitterServiceSettings"/> instance initialized with the values from the dictionary.</returns>
        public static TokenTextSplitterServiceSettings FromDictionary(Dictionary<string, string> settings)
        {
            if (settings.TryGetValue("TokenizerEncoder", out var tokenizerEncoder)
                && settings.TryGetValue("ChunkSizeTokens", out var chunkSizeTokens)
                && settings.TryGetValue("OverlapSizeTokens", out var overlapSizeTokens))
                return new TokenTextSplitterServiceSettings()
                {
                    TokenizerEncoder = tokenizerEncoder,
                    ChunkSizeTokens = int.Parse(chunkSizeTokens),
                    OverlapSizeTokens = int.Parse(overlapSizeTokens)
                };

            throw new TextProcessingException("Invalid text splitter settings.");
        }
    }
}
