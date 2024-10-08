using BuildYourOwnCopilot.Infrastructure.Exceptions;
using BuildYourOwnCopilot.Infrastructure.Interfaces;
using Microsoft.Extensions.Logging;
using System.Collections.ObjectModel;

namespace BuildYourOwnCopilot.Infrastructure.Services.Text
{
    /// <summary>
    /// Implements an <see cref="ITokenizerService"/> using the Microsoft BPE tokenizer (https://github.com/microsoft/Tokenizer).
    /// This class should always be instantiated as a singleton when used in dependency injection scenarios.
    /// </summary>
    public class MicrosoftBPETokenizerService : ITokenizerService
    {
        private readonly Dictionary<string, List<LeasedTikTokenizer>> _tokenizers = [];
        private readonly ManualResetEventSlim _initializationComplete = new();
        private readonly object _syncRoot = new();
        private readonly ReadOnlyDictionary<string, TikTokenizerConfig> _encoderConfigurations = new Dictionary<string, TikTokenizerConfig>()
        {
            {
                TikTokenizerEncoders.CL100K_BASE,
                new TikTokenizerConfig(
                    @"(?i:'s|'t|'re|'ve|'m|'ll|'d)|[^\r\n\p{L}\p{N}]?\p{L}+|\p{N}{1,3}| ?[^\s\p{L}\p{N}]+[\r\n]*|\s*[\r\n]+|\s+(?!\S)|\s+",
                    @"https://openaipublic.blob.core.windows.net/encodings/cl100k_base.tiktoken",
                    new Dictionary<string, int>{
                                                { TikTokenizerTokens.ENDOFTEXT, 100257},
                                                { TikTokenizerTokens.FIM_PREFIX, 100258},
                                                { TikTokenizerTokens.FIM_MIDDLE, 100259},
                                                { TikTokenizerTokens.FIM_SUFFIX, 100260},
                                                { TikTokenizerTokens.ENDOFPROMPT, 100276}
                                            })}
        }.AsReadOnly();

        private readonly ILogger<MicrosoftBPETokenizerService> _logger;

        private const int TOKENIZER_LIST_INITIAL_SIZE = 10;
        private const int TOKENIZER_CACHE_SIZE = 8192;

        /// <summary>
        /// Initializes a new instance of the <see cref="MicrosoftBPETokenizerService"/> class.
        /// </summary>
        /// <param name="logger">The logger used for logging.</param>
        public MicrosoftBPETokenizerService(
            ILogger<MicrosoftBPETokenizerService> logger)
        {
            _logger = logger;

            // Kicks off the initialization on a separate thread and does not wait for it to complete.
            // The completion of the initialization process will be signaled by setting the _initializationComplete event.
            _ = Task.Run(Initialize);
        }

        /// <inheritdoc/>
        public List<int> Encode(string text, string encoderName)
        {
            _initializationComplete.Wait();

            ValidateEncoder(encoderName);
            var tokenizer = GetTokenizer(encoderName)
                ?? throw new TextProcessingException($"Could not retrieve a valid tokenizer for the {encoderName} encoder.");
            try
            {
                return tokenizer.Encode(text);
            }
            finally
            {
                ReleaseTokenizer(tokenizer);
            }
        }

        /// <inheritdoc/>
        public string Decode(int[] tokens, string encoderName)
        {
            _initializationComplete.Wait();

            ValidateEncoder(encoderName);
            var tokenizer = GetTokenizer(encoderName)
                ?? throw new TextProcessingException($"Could not retrieve a valid tokenizer for the {encoderName} encoder.");
            try
            {
                return tokenizer.Decode(tokens);
            }
            finally
            {
                ReleaseTokenizer(tokenizer);
            }
        }

        private async Task Initialize()
        {
            _logger.LogInformation("Starting to initialize the Microsoft BPE tokenizer service...");

            // Download BPE rank files and cache their contents as memory streams.
            await DownloadBPEFiles();

            // Create and cache multiple instances of tokenizers.
            // This is needed because the TikTokenizer class does not appear to be thread safe.
            CreateTokenizers();

            _logger.LogInformation("The Microsoft BPE tokenizer service was successfully initialized.");

            // Signal the completion of the initialization process.
            _initializationComplete.Set();
        }

        private async Task DownloadBPEFiles()
        {
            var httpClient = new HttpClient();

            foreach (var tokenizerConfig in _encoderConfigurations)
            {
                try
                {
                    _logger.LogInformation("Starting to download BPE rank file from {FileUrl} ...", tokenizerConfig.Value.MergeableRanksFileUrl);
                    tokenizerConfig.Value.MergeableRanksFileContent = await httpClient.GetByteArrayAsync(tokenizerConfig.Value.MergeableRanksFileUrl);
                    _logger.LogInformation("BPE rank file successfully downloaded from {FileUrl}.", tokenizerConfig.Value.MergeableRanksFileUrl);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error downloading BPE rank file from {FileUrl}.", tokenizerConfig.Value.MergeableRanksFileUrl);
                }
            }
        }

        private void CreateTokenizers()
        {
            foreach (var tokenizerConfig in _encoderConfigurations)
                if (tokenizerConfig.Value.MergeableRanksFileContent is not null)
                {
                    try
                    {
                        _logger.LogInformation("Starting to create tokenizer instances for the {EncoderName} encoder.", tokenizerConfig.Key);

                        var newTokenizers = new List<LeasedTikTokenizer>();

                        foreach (var index in Enumerable.Range(0, TOKENIZER_LIST_INITIAL_SIZE))
                        {
                            newTokenizers.Add(new LeasedTikTokenizer(
                                new MemoryStream(tokenizerConfig.Value.MergeableRanksFileContent),
                                tokenizerConfig.Value.SpecialTokens,
                                tokenizerConfig.Value.RegexPattern,
                                TOKENIZER_CACHE_SIZE));
                        }
                        _tokenizers[tokenizerConfig.Key] = newTokenizers;

                        _logger.LogInformation("Tokenizer instances successfully created for the {EncoderName} encoder.", tokenizerConfig.Key);
                    }
                    catch (Exception ex)
                    {
                        _logger.LogError(ex, "Error creating tokenizer instances for the {EncoderName} encoder.", tokenizerConfig.Key);
                    }
                }
                else
                    _logger.LogWarning("The {EncoderName} encoder does not have a cached BPE rank file.", tokenizerConfig.Key);
        }

        private void ValidateEncoder(string encoderName)
        {
            if (string.IsNullOrWhiteSpace(encoderName)
                || (!_encoderConfigurations.TryGetValue(encoderName, out TikTokenizerConfig? value))
                || (value.MergeableRanksFileContent is null))
                throw new TextProcessingException($"The encoder {encoderName} is either not supported or has an invalid configuration.");
        }

        private LeasedTikTokenizer? GetTokenizer(string encoderName)
        {
            lock (_syncRoot)
            {
                if (!(_tokenizers.TryGetValue(encoderName, out List<LeasedTikTokenizer>? encoderTokenizers)))
                    return null;

                var tokenizerConfig = _encoderConfigurations[encoderName];

                var tokenizer = encoderTokenizers.FirstOrDefault(t => !t.IsLeased);
                if (tokenizer == null)
                {
                    // There are no tokenizer instances available for lease.
                    _logger.LogWarning("All {TokenizerInstanceCount} tokenizers for the {EncoderName} are currently leased. Adding a new tokenizer instance to the cache.",
                        encoderTokenizers.Count, encoderName);
                    var newTokenizer = new LeasedTikTokenizer(
                        new MemoryStream(tokenizerConfig.MergeableRanksFileContent!),
                        tokenizerConfig.SpecialTokens,
                        tokenizerConfig.RegexPattern,
                        TOKENIZER_CACHE_SIZE)
                    {
                        IsLeased = true
                    };
                    encoderTokenizers.Add(newTokenizer);
                    return newTokenizer;
                }
                else
                {
                    tokenizer.IsLeased = true;
                    return tokenizer;
                }
            }
        }

        private void ReleaseTokenizer(LeasedTikTokenizer tokenizer)
        {
            lock (_syncRoot)
            {
                if (tokenizer == null)
                    throw new TextProcessingException("Attempted to release a null tokenizer instance.");
                tokenizer.IsLeased = false;
            }
        }
    }
}
