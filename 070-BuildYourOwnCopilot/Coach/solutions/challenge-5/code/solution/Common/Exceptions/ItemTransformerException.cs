namespace BuildYourOwnCopilot.Common.Exceptions
{
    /// <summary>
    /// Represents an error in the tokenization process.
    /// </summary>
    public class ItemTransformerException : Exception
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ItemTransformerException"/> class with a default message.
        /// </summary>
        public ItemTransformerException()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ItemTransformerException"/> class with its message set to <paramref name="message"/>.
        /// </summary>
        /// <param name="message">A string that describes the error.</param>
        public ItemTransformerException(string? message) : base(message)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ItemTransformerException"/> class with its message set to <paramref name="message"/>.
        /// </summary>
        /// <param name="message">A string that describes the error.</param>
        /// <param name="innerException">The exception that is the cause of the current exception.</param>
        public ItemTransformerException(string? message, Exception? innerException) : base(message, innerException)
        {
        }
    }
}
