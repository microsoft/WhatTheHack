namespace BuildYourOwnCopilot.Common.Text
{
    public static class StringExtensions
    {
        public static string NormalizeLineEndings(this string src)
        {
            return src.ReplaceLineEndings("\n");
        }
    }
}
