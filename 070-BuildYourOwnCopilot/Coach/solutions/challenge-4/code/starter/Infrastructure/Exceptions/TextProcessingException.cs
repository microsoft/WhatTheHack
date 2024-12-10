namespace BuildYourOwnCopilot.Infrastructure.Exceptions
{
    /// <summary>
    /// Represents an error in the tokenization process.
    /// </summary>
    public class TextProcessingException : Exception
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="TextProcessingException"/> class with a default message.
        /// </summary>
        public TextProcessingException()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="TextProcessingException"/> class with its message set to <paramref name="message"/>.
        /// </summary>
        /// <param name="message">A string that describes the error.</param>
        public TextProcessingException(string? message) : base(message)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="TextProcessingException"/> class with its message set to <paramref name="message"/>.
        /// </summary>
        /// <param name="message">A string that describes the error.</param>
        /// <param name="innerException">The exception that is the cause of the current exception.</param>
        public TextProcessingException(string? message, Exception? innerException) : base(message, innerException)
        {
        }
    }
}
