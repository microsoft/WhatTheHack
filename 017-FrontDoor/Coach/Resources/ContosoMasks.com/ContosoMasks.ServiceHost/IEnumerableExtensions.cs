using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace System.Collections.Generic
{
    public static class IEnumerableExtensions
    {
        public static T SafeFirstOrDefault<T>(this IEnumerable<T> enumeration, Func<T, bool> action = null)
        {
            if (!enumeration.SafeAny()) return default(T);
            return action != null ? enumeration.FirstOrDefault(action) : enumeration.FirstOrDefault();
        }
        public static bool SafeAny<T>(this IEnumerable<T> enumeration, Func<T, bool> action = null)
        {
            return enumeration != null && (action != null ? enumeration.Any(action) : enumeration.Any());
        }

        public static int SafeCount<T>(this IEnumerable<T> enumeration, Func<T, bool> action = null)
        {
            if (action == null)
            {
                return enumeration.SafeAny() ? enumeration.Count() : 0;
            }
            else
            {
                return enumeration.SafeAny(action) ? enumeration.Count(action) : 0;
            }
        }

        public static void SafeForEach<T>(this IEnumerable<T> enumeration, Action<T> action)
        {
            if ( !enumeration.SafeAny() )
            {
                return;
            }

            foreach (T item in enumeration)
            {
                action(item);
            }
        }

        public static IEnumerable<T> SafeWhere<T>(this IEnumerable<T> enumeration, Func<T, bool> action)
        {
            if (!enumeration.SafeAny())
            {
                return Enumerable.Empty<T>();
            }

            return enumeration.Where(action);
        }

        public static IEnumerable<Ret> SafeSelect<T, Ret>(this IEnumerable<T> enumeration, Func<T, Ret> action)
        {
            if (!enumeration.SafeAny())
            {
                return Enumerable.Empty<Ret>();
            }

            return enumeration.Select(action);
        }
    }
}
