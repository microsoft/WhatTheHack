using Microsoft.ML.Tokenizers;

namespace BuildYourOwnCopilot.SemanticKernel.Chat
{
    public class MicrosoftMLTokenizer : ITokenizer
    {
        public int GetTokensCount(string text)
        {
            var tokenizer = new Tokenizer(new Bpe());
            var tokens = tokenizer.Encode(text).Tokens;

            return tokens.Count;
        }
    }
}
