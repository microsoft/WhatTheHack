namespace BuildYourOwnCopilot.Infrastructure.Exceptions
{
    /// <summary>
    /// Represents an error in the tokenization process.
    /// </summary>
    public class CosmosDBException : Exception
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="CosmosDBException"/> class with a default message.
        /// </summary>
        public CosmosDBException()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="CosmosDBException"/> class with its message set to <paramref name="message"/>.
        /// </summary>
        /// <param name="message">A string that describes the error.</param>
        public CosmosDBException(string? message) : base(message)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="CosmosDBException"/> class with its message set to <paramref name="message"/>.
        /// </summary>
        /// <param name="message">A string that describes the error.</param>
        /// <param name="innerException">The exception that is the cause of the current exception.</param>
        public CosmosDBException(string? message, Exception? innerException) : base(message, innerException)
        {
        }
    }
}
