namespace BuildYourOwnCopilot.Infrastructure.Interfaces
{
    /// <summary>
    /// Represents a text splitter.
    /// </summary>
    public interface ITextSplitterService
    {
        /// <summary>
        /// Splits plain text into multiple chunks.
        /// </summary>
        /// <param name="text">The plain text to split.</param>
        /// <returns>A list of strings containing the result of the split and a message with optional details about the split result.</returns>
        (List<string> TextChunks, string Message) SplitPlainText(string text);
    }
}
