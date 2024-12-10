namespace BuildYourOwnCopilot.Infrastructure.Services.Text
{
    /// <summary>
    /// Provides the configuration values required to create a new <see cref="TikTokenizer"/> instance.
    /// </summary>
    /// <param name="RegexPattern">Regex pattern to break a long string.</param>
    /// <param name="MergeableRanksFileUrl">The URL used to download the BPE rank file.</param>
    /// <param name="SpecialTokens">Special tokens mapping.</param>
    public record TikTokenizerConfig(
        string RegexPattern,
        string MergeableRanksFileUrl,
        Dictionary<string, int> SpecialTokens)
    {
        /// <summary>
        /// The raw content of the BPE rank file.
        /// </summary>
        public byte[]? MergeableRanksFileContent { get; set; }
    }
}
