using System.Reflection;

namespace BuildYourOwnCopilot.Common.Extensions
{
    public static class ObjectExtensions
    {
        /// <summary>
        /// Gets the values of a specified set of properties of an object.
        /// </summary>
        /// <param name="obj">The object instance.</param>
        /// <param name="propertyNames">The list of property names.</param>
        /// <returns></returns>
        public static List<string> GetPropertyValues(this object obj, List<string> propertyNames) 
        {
            var type = obj.GetType();

            // Only string properties are considered
            // Only properties with public getters are considered
            return type.GetProperties(BindingFlags.Public | BindingFlags.Instance)
                .Where(p => p.PropertyType == typeof(string) && p.CanRead && propertyNames.Contains(p.Name))
                .Select(p => p.GetGetMethod(false))
                .Where(mget => mget != null)
                .Select(mget => (string)mget.Invoke(obj, null))
                .Where(s => !string.IsNullOrEmpty(s))
                .ToList();
        }
    }
}
