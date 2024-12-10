using System.Security.Cryptography;
using System.Text;

namespace BuildYourOwnCopilot.Common.Extensions
{
    public static class StringExtensions
    {
        private static readonly SHA1 _hashAlgorithm = SHA1.Create();

        /// <summary>
        /// Calculates the hash of the string.
        /// </summary>
        /// <param name="s">The string to be hashed.</param>
        /// <returns>The SHA1 hash of the string.</returns>
        public static string GetHash(this string s)
        {
            return Convert.ToBase64String(
                _hashAlgorithm.ComputeHash(
                    Encoding.UTF8.GetBytes(s)));
        }
    }
}
