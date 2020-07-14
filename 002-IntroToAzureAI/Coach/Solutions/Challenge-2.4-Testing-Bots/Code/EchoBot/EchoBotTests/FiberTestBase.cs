using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Bot.Connector;
using Microsoft.Bot.Builder.Dialogs;
using System.Threading.Tasks;
using Autofac;
using Microsoft.Bot.Builder.Dialogs.Internals;
using Microsoft.Bot.Builder.Base;
using System.Threading;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization;
using System.Reflection;
using Microsoft.Bot.Builder.Internals.Fibers;
using System.Linq.Expressions;

namespace EchoBotTests
{
    [TestClass]
    public abstract class FiberTestBase
    {
        public struct C
        {
        }

        public static readonly C Context = default(C);
        public static readonly CancellationToken Token = new CancellationTokenSource().Token;

        public interface IMethod
        {
            Task<IWait<C>> CodeAsync<T>(IFiber<C> fiber, C context, IAwaitable<T> item, CancellationToken token);
        }

        public static Moq.Mock<IMethod> MockMethod()
        {
            var method = new Moq.Mock<IMethod>(Moq.MockBehavior.Loose);
            return method;
        }

        public static Expression<Func<IAwaitable<T>, bool>> Item<T>(T value)
        {
            return item => value.Equals(item.GetAwaiter().GetResult());
        }

        protected sealed class CodeException : Exception
        {
        }

        public static bool ExceptionOfType<T, E>(IAwaitable<T> item) where E : Exception
        {
            try
            {
                item.GetAwaiter().GetResult();
                return false;
            }
            catch (E)
            {
                return true;
            }
            catch
            {
                return false;
            }
        }

        public static Expression<Func<IAwaitable<T>, bool>> ExceptionOfType<T, E>() where E : Exception
        {
            return item => ExceptionOfType<T, E>(item);
        }

        public static async Task PollAsync(IFiberLoop<C> fiber)
        {
            IWait wait;
            do
            {
                wait = await fiber.PollAsync(Context, Token);
            }
            while (wait.Need != Need.None && wait.Need != Need.Done);
        }

        public static IContainer Build()
        {
            var builder = new ContainerBuilder();
            builder.RegisterModule(new FiberModule<C>());
            return builder.Build();
        }

        public sealed class ResolveMoqAssembly : IDisposable
        {
            private readonly object[] instances;
            public ResolveMoqAssembly(params object[] instances)
            {
                SetField.NotNull(out this.instances, nameof(instances), instances);

                AppDomain.CurrentDomain.AssemblyResolve += CurrentDomain_AssemblyResolve;
            }
            void IDisposable.Dispose()
            {
                AppDomain.CurrentDomain.AssemblyResolve -= CurrentDomain_AssemblyResolve;
            }
            private Assembly CurrentDomain_AssemblyResolve(object sender, ResolveEventArgs arguments)
            {
                foreach (var instance in instances)
                {
                    var type = instance.GetType();
                    if (arguments.Name == type.Assembly.FullName)
                    {
                        return type.Assembly;
                    }
                }

                return null;
            }
        }

        public static void AssertSerializable<T>(ILifetimeScope scope, ref T item) where T : class
        {
            var formatter = scope.Resolve<IFormatter>();

            using (var stream = new MemoryStream())
            {
                formatter.Serialize(stream, item);
                stream.Position = 0;
                item = (T)formatter.Deserialize(stream);
            }
        }
    }
}
