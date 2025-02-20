namespace BuildYourOwnCopilot.Infrastructure.Services.Text
{
    /// <summary>
    /// Well-known special TikTokenizer token names.
    /// </summary>
    public static class TikTokenizerTokens
    {
        /// <summary>
        /// End of text token.
        /// </summary>
        public const string ENDOFTEXT = "<|endoftext|>";
        /// <summary>
        /// Fill-In-the-Middle (FIM) prefix token.
        /// For details see https://arxiv.org/abs/2207.14255 and https://github.com/openai/human-eval-infilling.
        /// </summary>
        public const string FIM_PREFIX = "<|fim_prefix|>";
        /// <summary>
        /// Fill-In-the-Middle (FIM) middle token.
        /// For details see https://arxiv.org/abs/2207.14255 and https://github.com/openai/human-eval-infilling.
        /// </summary>
        public const string FIM_MIDDLE = "<|fim_middle|>";
        /// <summary>
        /// Fill-In-the-Middle (FIM) suffix token.
        /// For details see https://arxiv.org/abs/2207.14255 and https://github.com/openai/human-eval-infilling.
        /// </summary>
        public const string FIM_SUFFIX = "<|fim_suffix|>";
        /// <summary>
        /// End of prompt token.
        /// </summary>
        public const string ENDOFPROMPT = "<|endofprompt|>";
    }
}
