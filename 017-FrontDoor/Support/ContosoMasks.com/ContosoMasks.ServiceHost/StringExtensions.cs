using System;
using System.Collections.Generic;
using System.Security;
using System.Text;
using System.Xml.Linq;

namespace System
{
    public static class StringExtensions
    {
        public static bool EqualsOI(this string sourceString, string targetString)
        {
            return string.Equals(sourceString, targetString, StringComparison.OrdinalIgnoreCase);
        }

        // https://weblog.west-wind.com/posts/2018/Nov/30/Returning-an-XML-Encoded-String-in-NET

        public static string XMLEncode(this string sourceString, bool isAttribute = false)
        {
            if (string.IsNullOrEmpty(sourceString))
                return sourceString;

            if (!isAttribute)
            {
                return new XElement("t", sourceString).LastNode.ToString();
            }

            return (new XAttribute("__n", sourceString)).ToString().Substring(5).TrimEnd('\"');
        }

        // https://dotnetcodr.com/2016/08/19/how-to-convert-a-plain-string-into-a-secure-string-with-c/
        public static SecureString ToSecureString(this string plainString)
        {
            if (plainString == null)
                return null;

            SecureString secureString = new SecureString();
            foreach (char c in plainString.ToCharArray())
            {
                secureString.AppendChar(c);
            }
            return secureString;
        }
    }
}
