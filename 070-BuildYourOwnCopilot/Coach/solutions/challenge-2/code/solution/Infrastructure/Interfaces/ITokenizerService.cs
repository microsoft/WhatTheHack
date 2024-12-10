namespace BuildYourOwnCopilot.Infrastructure.Interfaces
{
    /// <summary>
    /// Represents a text tokenizer.
    /// </summary>
    public interface ITokenizerService
    {
        /// <summary>
        /// Encode a string with a set of allowed special tokens that are not broken apart.
        /// </summary>
        /// <param name="text">String to be encoded.</param>
        /// <param name="encoderName"> The name of the encoder used for tokenization.</param>
        /// <returns>List of token ids.</returns>
        List<int> Encode(string text, string encoderName);

        /// <summary>
        /// Decode an array of integer token ids.
        /// </summary>
        /// <param name="tokens">An array of integer token ids.</param>
        /// <param name="encoderName"> The name of the encoder used for tokenization.</param>
        /// <returns>Decoded text.</returns>
        string Decode(int[] tokens, string encoderName);
    }
}
