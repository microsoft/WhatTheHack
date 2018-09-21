// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Bot.Builder;

namespace PictureBot
{
    public interface IRecognizedIntents
    {
        Intent TopIntent { get; set; }
        IList<Intent> Intents { get; set; }
    }
    public class IntentRecognition : IRecognizedIntents
    {
        public IntentRecognition()
        {
        }

        public Intent TopIntent { get; set; }
        public IList<Intent> Intents { get; set; } = new Intent[0];
    }

    public class Intent
    {
        public string Name { get; set; }
        public double Score { get; set; }

        public IList<Entity> Entities { get; } = new List<Entity>();
    }


    public class IntentRecognizerMiddleware : IMiddleware
    {
        public delegate Task<Boolean> IntentDisabler(ITurnContext context);
        public delegate Task<IList<Intent>> IntentRecognizer(ITurnContext context);
        public delegate Task IntentResultMutator(ITurnContext context, IList<Intent> intents);

        private readonly LinkedList<IntentDisabler> _intentDisablers = new LinkedList<IntentDisabler>();
        private readonly LinkedList<IntentRecognizer> _intentRecognizers = new LinkedList<IntentRecognizer>();
        private readonly LinkedList<IntentResultMutator> _intentResultMutators = new LinkedList<IntentResultMutator>();

        /// <summary>
        /// method for accessing recognized intents added by middleware to context
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public static IRecognizedIntents Get(ITurnContext context) { return context.Services.Get<IRecognizedIntents>(); }

        public async Task OnTurn(ITurnContext context, MiddlewareSet.NextDelegate next)
        {
            BotAssert.ContextNotNull(context);

            var intents = await this.Recognize(context);
            var result = new IntentRecognition();
            if (intents.Count != 0)
            {
                result.Intents = intents;
                var topIntent = FindTopIntent(intents);
                if (topIntent.Score > 0.0)
                {
                    result.TopIntent = topIntent;
                }
            }
            context.Services.Add((IRecognizedIntents)result);
            await next().ConfigureAwait(false);
        }

        public async Task<IList<Intent>> Recognize(ITurnContext context)
        {
            BotAssert.ContextNotNull(context);

            bool isEnabled = await IsRecognizerEnabled(context).ConfigureAwait(false);
            if (isEnabled)
            {
                var allRecognizedIntents = await RunRecognizer(context).ConfigureAwait(false);
                await RunFilters(context, allRecognizedIntents);
                return allRecognizedIntents;
            }
            else
            {
                return new List<Intent>();
            }
        }

        private async Task<IList<Intent>> RunRecognizer(ITurnContext context)
        {
            List<Intent> allRecognizedIntents = new List<Intent>();

            foreach (var recognizer in _intentRecognizers)
            {
                IList<Intent> intents = await recognizer(context).ConfigureAwait(false);
                if (intents != null && intents.Count > 0)
                {
                    allRecognizedIntents.AddRange(intents);
                }
            }

            return allRecognizedIntents;
        }

        private async Task<Boolean> IsRecognizerEnabled(ITurnContext context)
        {
            foreach (var userCode in _intentDisablers)
            {
                bool isEnabled = await userCode(context).ConfigureAwait(false);
                if (isEnabled == false)
                {
                    return false;
                }
            }

            return true;
        }

        private async Task RunFilters(ITurnContext context, IList<Intent> intents)
        {
            foreach (var filter in _intentResultMutators)
            {
                await filter(context, intents);
            }
        }

        /// <summary>
        /// An IntentDisabler that's registered here will fire BEFORE the intent recognizer code
        /// is run, and will have the oppertunity to prevent the recognizer from running. 
        /// 
        /// As soon as one function returns 'Do Not Run' no further methods will be called. 
        /// 
        /// Enabled/Disabled methods that are registered are run in the order registered. 
        /// </summary>        
        public IntentRecognizerMiddleware OnEnabled(IntentDisabler preCondition)
        {
            if (preCondition == null)
                throw new ArgumentNullException(nameof(preCondition));

            _intentDisablers.AddLast(preCondition);

            return this;
        }

        /// <summary>
        /// Recognizer methods are run in the ordered registered.
        /// </summary>
        public IntentRecognizerMiddleware OnRecognize(IntentRecognizer recognizer)
        {
            if (recognizer == null)
                throw new ArgumentNullException(nameof(recognizer));

            _intentRecognizers.AddLast(recognizer);

            return this;
        }

        /// <summary>
        /// Filter method are run in REVERSE order registered. That is, they are run from "last -> first". 
        /// </summary>
        public IntentRecognizerMiddleware OnFilter(IntentResultMutator postCondition)
        {
            if (postCondition == null)
                throw new ArgumentNullException(nameof(postCondition));

            _intentResultMutators.AddFirst(postCondition);

            return this;
        }

        public static Intent FindTopIntent(IList<Intent> intents)
        {
            if (intents == null)
                throw new ArgumentNullException(nameof(intents));

            var enumerator = intents.GetEnumerator();
            if (!enumerator.MoveNext())
                throw new ArgumentException($"No Intents on '{nameof(intents)}'");

            var topIntent = enumerator.Current;
            var topScore = topIntent.Score;

            while (enumerator.MoveNext())
            {
                var currVal = enumerator.Current.Score;

                if (currVal.CompareTo(topScore) > 0)
                {
                    topScore = currVal;
                    topIntent = enumerator.Current;
                }
            }
            return topIntent;
        }
        public static string CleanString(string s)
        {
            return string.IsNullOrWhiteSpace(s) ? string.Empty : s.Trim();
        }

    }
}