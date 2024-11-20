using BuildYourOwnCopilot.Infrastructure.Exceptions;
using BuildYourOwnCopilot.Infrastructure.Interfaces;
using BuildYourOwnCopilot.Infrastructure.Models.ConfigurationOptions;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace BuildYourOwnCopilot.Infrastructure.Services.Text
{

    /// <summary>
    /// Splits text based on number of tokens.
    /// </summary>
    /// <param name="tokenizerService">The <see cref="ITokenizerService"/> used to tokenize the input text.</param>
    /// <param name="options">The <see cref="IOptions{TOptions}"/> providing the settings for the service.</param>
    /// <param name="logger">The logger used for logging.</param>
    public class TokenTextSplitterService(
        ITokenizerService tokenizerService,
        IOptions<TokenTextSplitterServiceSettings> options,
        ILogger<TokenTextSplitterService> logger) : ITextSplitterService
    {
        private readonly ITokenizerService _tokenizerService = tokenizerService;
        private readonly TokenTextSplitterServiceSettings _settings = options.Value;
        private readonly ILogger<TokenTextSplitterService> _logger = logger;

        /// <inheritdoc/>
        public (List<string> TextChunks, string Message) SplitPlainText(string text)
        {
            var tokens = _tokenizerService.Encode(text, _settings.TokenizerEncoder!);

            if (tokens != null)
            {
                _logger.LogInformation("The tokenizer identified {TokensCount} tokens.", tokens.Count);

                var chunksCount = (int)Math.Ceiling((1f * tokens!.Count - _settings.OverlapSizeTokens) / (_settings.ChunkSizeTokens - _settings.OverlapSizeTokens));

                if (chunksCount <= 1)
                    return (new List<string> { text }, $"The number of text chunks is {chunksCount}. The size of the last chunk is {tokens.Count} tokens.");

                var chunks = Enumerable.Range(0, chunksCount - 1)
                    .Select(i => tokens.Skip(i * (_settings.ChunkSizeTokens - _settings.OverlapSizeTokens)).Take(_settings.ChunkSizeTokens).ToArray())
                    .Select(t => _tokenizerService.Decode(t, _settings.TokenizerEncoder))
                    .ToList();

                var lastChunkStart = (chunksCount - 1) * (_settings.ChunkSizeTokens - _settings.OverlapSizeTokens);
                var lastChunkSize = tokens.Count - lastChunkStart + 1;
                var resultMessage = string.Empty;

                if (lastChunkSize < 2 * _settings.OverlapSizeTokens)
                {
                    // The last chunk is to small, will just incorporate it into the second to last.
                    var secondToLastChunkStart = (chunksCount - 2) * (_settings.ChunkSizeTokens - _settings.OverlapSizeTokens);
                    var newLastChunkSize = tokens.Count - secondToLastChunkStart + 1;
                    var newLastChunk = _tokenizerService.Decode(
                        tokens
                            .Skip(secondToLastChunkStart)
                            .Take(newLastChunkSize)
                            .ToArray(),
                        _settings.TokenizerEncoder);
                    chunks.RemoveAt(chunks.Count - 1);
                    chunks.Add(newLastChunk);

                    resultMessage = $"The number of text chunks is {chunks.Count}. The size of the last chunk is {newLastChunkSize} tokens.";
                }
                else
                {
                    var lastChunk = _tokenizerService.Decode(
                        tokens
                            .Skip(lastChunkStart)
                            .Take(lastChunkSize)
                            .ToArray(),
                        _settings.TokenizerEncoder);
                    chunks.Add(lastChunk);

                    resultMessage = $"The number of text chunks is {chunks.Count}. The size of the last chunk is {lastChunkSize} tokens.";
                }

                return new(chunks, resultMessage);
            }
            else
                throw new TextProcessingException("The tokenizer service failed to split the text into tokens.");
        }
    }
}
