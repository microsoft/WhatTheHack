using Microsoft.SemanticKernel.ChatCompletion;
using Newtonsoft.Json;
using System.Text;
using BuildYourOwnCopilot.Common.Text;

namespace BuildYourOwnCopilot.SemanticKernel.Chat
{
    public class ContextBuilder
    {
        readonly int _maxTokens;
        readonly int _maxPromptTokens;
        readonly Dictionary<string, Type> _memoryTypes;
        readonly ITokenizer? _tokenizer;
        readonly PromptOptimizationSettings? _promptOptimizationSettings;

        const int BufferTokens = 50;

        string _systemPrompt = string.Empty;
        List<object> _memories = new List<object>();
        List<(AuthorRole AuthorRole, string Content)> _messages = new List<(AuthorRole AuthorRole, string Content)>();

        public ContextBuilder(
            int maxTokens,
            Dictionary<string, Type> memoryTypes,
            ITokenizer? tokenizer = null,
            PromptOptimizationSettings? promptOptimizationSettings = null) 
        {
            _maxTokens = maxTokens;
            _memoryTypes = memoryTypes;

            // If no external tokenizer has been provided, use our own
            _tokenizer = tokenizer ?? new MicrosoftMLTokenizer();
            
            _promptOptimizationSettings = promptOptimizationSettings != null
                ? promptOptimizationSettings
                : new PromptOptimizationSettings 
                {
                    CompletionsMinTokens = 50,
                    CompletionsMaxTokens = 300,
                    SystemMaxTokens = 1500,
                    MemoryMinTokens = 500,
                    MemoryMaxTokens = 2500,
                    MessagesMinTokens = 1000,
                    MessagesMaxTokens = 3000
                };

            // Use BufferTokens (default 50) tokens as a buffer for extra needs resulting from concatenation, new lines, etc.
            _maxPromptTokens = _maxTokens - _promptOptimizationSettings.CompletionsMaxTokens - BufferTokens;
        }

        public ContextBuilder WithSystemPrompt(string prompt)
        {
            ArgumentNullException.ThrowIfNullOrEmpty(prompt, nameof(prompt));
            _systemPrompt = prompt;
            return this;
        }

        public ContextBuilder WithMemories(List<string> memories)
        {
            ArgumentNullException.ThrowIfNull(memories, nameof(memories));

            // This function transforms the JSON into a more streamlined string of text, more suitable for generating responses
            // Use by default the JSON text representation based on EmbeddingFieldAttribute
            // TODO: Test also using the more elaborate text representation - itemToEmbed.TextToEmbed
            _memories = memories.Select(m => (object) EmbeddingUtility.Transform(m, _memoryTypes).TextToEmbed).ToList();
            return this;
        }

        public ContextBuilder WithMessageHistory(List<(AuthorRole AuthorRole, string Content)> messages) 
        {
            ArgumentNullException.ThrowIfNull(messages, nameof(messages));
            _messages = messages;
            return this;
        }

        public string Build()
        {
            OptimizePromptSize();

            var result = new StringBuilder();

            if (_memories.Count > 0)
            {
                var memoriesPrompt = string.Join(Environment.NewLine, _memories.Select(
                    m => $"{JsonConvert.SerializeObject(m)}{Environment.NewLine}---------------------------{Environment.NewLine}").ToArray());
                result.Append($"Context:{Environment.NewLine}{Environment.NewLine}{memoriesPrompt}{Environment.NewLine}{Environment.NewLine}".NormalizeLineEndings());
            }

            if (_messages.Count > 0)
            {
                result.Append($"The history of the current conversation is:{Environment.NewLine}{Environment.NewLine}".NormalizeLineEndings());
                foreach (var message in _messages)
                    result.Append($"{message.AuthorRole}: {message.Content}{Environment.NewLine}".NormalizeLineEndings());
            }

            return result.ToString();
        }

        private void OptimizePromptSize()
        {
            var systemPromptTokens = _tokenizer!.GetTokensCount(_systemPrompt);

            var memories = _memories.Select(m => new
            {
                Memory = m,
                Tokens = _tokenizer.GetTokensCount(JsonConvert.SerializeObject(m).NormalizeLineEndings())
            }).ToList();

            // Keep in reverse order because we need to keep the most recents messages
            var messages = _messages.Select(m => new
            {
                Message = m,
                Tokens = _tokenizer.GetTokensCount(m.Content)
            }).Reverse().ToList();

            // All systems green?
            var totalTokens = systemPromptTokens + memories.Sum(mt => mt.Tokens) + messages.Sum(mt => mt.Tokens) + BufferTokens;
            if (totalTokens <= _maxPromptTokens)
                // We're good, not reaching the limit
                return;

            // Start trimming down things to fit within the defined constraints

            if (systemPromptTokens > _promptOptimizationSettings!.SystemMaxTokens)
                throw new Exception($"The estimated size of the core system prompt ({systemPromptTokens} tokens) exceeds the configured maximum of {_promptOptimizationSettings.SystemMaxTokens}.");

            // Limit memories

            var tmpMemoryTokens = 0;
            var validMemoriesCount = 0;

            foreach (var m in memories)
            {
                tmpMemoryTokens += m.Tokens;
                if (tmpMemoryTokens <= _promptOptimizationSettings.MemoryMaxTokens)
                    validMemoriesCount++;
                else
                    break;
            }

            // Keep the memories that allow us to obey the limit rule (still in reverse order as we might need to further limit)
            memories = memories.Take(validMemoriesCount).ToList();
            _memories = memories.Select(m => m.Memory).ToList();

            var tmpMessagesTokens = 0;
            var validMessagesCount = 0;

            foreach(var m in messages)
            {
                tmpMessagesTokens += m.Tokens;
                if (tmpMessagesTokens <= _promptOptimizationSettings.MessagesMaxTokens)
                    validMessagesCount++;
                else
                    break;
            }

            // Keep the messages that allow us to obey the limit rule (still in reverse order as we might need to further limit)
            messages = messages.Take(validMessagesCount).ToList();
            _messages = messages.Select(m => m.Message).Reverse().ToList();

            // All systems green?
            var memoryTokens = memories.Sum(mt => mt.Tokens);
            var messagesTokens = messages.Sum(mt => mt.Tokens);
            totalTokens = systemPromptTokens + memoryTokens + messagesTokens + BufferTokens;
            if (totalTokens <= _maxPromptTokens)
                // We're good, just got below the overall limit using the configured max limits for memories and messages
                return;

            // Still not good, so continue trimming down things

            // Eliminate one memory at a time in reverse order until we either reach the token goal or we fall bellow the minimum memory token count
            for (int i = memories.Count - 1; i >= 0; i--)
            {
                if (memoryTokens - memories[i].Tokens < _promptOptimizationSettings.MemoryMinTokens
                    || totalTokens <= _maxPromptTokens)
                // This memory will not be eliminated because we've either got below the overall limit or its elimination will get us below the minimum memory token count
                {
                    memories = memories.Take(i + 1).ToList();
                    _memories = memories.Select(m => m.Memory).ToList();
                    memoryTokens = memories.Sum(mt => mt.Tokens);
                    break;
                }

                memoryTokens -= memories[i].Tokens;
                totalTokens -= memories[i].Tokens;
            }

            // All systems green?
            totalTokens = systemPromptTokens + memoryTokens + messagesTokens + BufferTokens;
            if (totalTokens <= _maxPromptTokens)
                // We're good, just got below the overall limit without reaching the lower limit for memory tokens
                return;

            // Still not good, so continue trimming down things

            // Eliminate one message at a time in reverse order until we either reach the token goal or we fall bellow the minimum memory token count
            for (int i = messages.Count - 1; i > 0; i--)
            {
                if (messagesTokens - messages[i].Tokens < _promptOptimizationSettings.MessagesMinTokens
                    || totalTokens <= _maxPromptTokens)
                // This message will not be eliminated because we've either got below the overall limit or its elimination will get us below the minimum messages token count
                {
                    messages = messages.Take(i + 1).ToList();
                    _messages = messages.Select(m => m.Message).Reverse().ToList();
                    messagesTokens = messages.Sum(mt => mt.Tokens);
                    break;
                }

                messagesTokens -= messages[i].Tokens;
                totalTokens -= messages[i].Tokens;
            }

            // All systems green?
            totalTokens = systemPromptTokens + memoryTokens + messagesTokens + BufferTokens;
            if (totalTokens <= _maxPromptTokens)
                // We're good, just got below the overall limit without reaching the lower limit for messages tokens
                return;

            // Oops! The least significant memory and the least significant message are preventing us from getting below the overall limit

            // Remove the least significant memory
            totalTokens -= memories.Last().Tokens;
            memories.RemoveAt(memories.Count - 1);
            _memories = memories.Select(m => m.Memory).ToList();

            // All systems green?
            if (totalTokens <= _maxPromptTokens)
                // We're good, just got below the overall limit by removing the least significant memory
                return;

            // Remove the least significant message
            totalTokens -= messages.Last().Tokens;
            messages.RemoveAt(messages.Count - 1);
            _messages = messages.Select(m => m.Message).Reverse().ToList();

            // All systems green?
            if (totalTokens <= _maxPromptTokens)
                // We're good, just got below the overall limit by removing the least significant message
                return;

            // Error! Most likely, the prompt optimization settings are inconsistent
            throw new Exception("Cannot produce a prompt using the current prompt optimization settings.");
        }


    }
}
