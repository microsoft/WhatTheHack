// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using Microsoft.Bot.Builder;

namespace PictureBot
{ 
    public class RegExpRecognizerSettings
    {
        /// <summary>
        /// Minimum score, on a scale from 0.0 to 1.0, that should be returned for a matched 
        /// expression.This defaults to a value of 0.0. 
        /// </summary>
        public double MinScore { get; set; } = 0.0;
    }

    public class RegExLocaleMap
    {
        private Dictionary<string, List<Regex>> _map = new Dictionary<string, List<Regex>>();
        private const string Default_Key = "*";

        public RegExLocaleMap()
        {
        }

        public RegExLocaleMap(List<Regex> items)
        {
            _map[Default_Key] = items;
        }

        public List<Regex> GetLocale(string locale)
        {
            if (_map.ContainsKey(locale))
                return _map[locale];
            else if (_map.ContainsKey(Default_Key))
                return _map[Default_Key];
            else
                return new List<Regex>();
        }

        public Dictionary<string, List<Regex>> Map
        {
            get { return _map; }
        }

    }

    public class RegExpRecognizerMiddleware : IntentRecognizerMiddleware
    {
        private RegExpRecognizerSettings _settings;
        private Dictionary<string, RegExLocaleMap> _intents = new Dictionary<string, RegExLocaleMap>();
        public const string DefaultEntityType = "string";

        public RegExpRecognizerMiddleware() : this(new RegExpRecognizerSettings() { MinScore = 0.0 })
        {
        }

        public RegExpRecognizerMiddleware(RegExpRecognizerSettings settings)
        {
            _settings = settings ?? throw new ArgumentNullException("settings");
            if (_settings.MinScore < 0 || _settings.MinScore > 1.0)
            {
                throw new ArgumentException($"RegExpRecognizerMiddleware: a minScore of {_settings.MinScore} is out of range.");
            }

            this.OnRecognize(async (context) =>
           {
               IList<Intent> intents = new List<Intent>();
               string utterance = CleanString(context.Activity.Text);
               double minScore = _settings.MinScore;

               foreach (var name in _intents.Keys)
               {
                   var map = _intents[name];
                   List<Regex> expressions = GetExpressions(context, map);
                   Intent top = null;
                   foreach (Regex exp in expressions)
                   {
                       List<string> entityTypes = new List<string>();
                       Intent intent = Recognize(utterance, exp, entityTypes, minScore);
                       if (intent != null)
                       {
                           if (top == null)
                           {
                               top = intent;
                           }
                           else if (intent.Score > top.Score)
                           {
                               top = intent;
                           }
                       }

                       if (top != null)
                       {
                           top.Name = name;
                           intents.Add(top);
                       }
                   }
               }
               return intents;
           });
        }

        public RegExpRecognizerMiddleware AddIntent(string intentName, Regex regex)
        {
            if (regex == null)
                throw new ArgumentNullException("regex");

            return AddIntent(intentName, new List<Regex> { regex });
        }
        public RegExpRecognizerMiddleware AddIntent(string intentName, List<Regex> regexList)
        {
            if (regexList == null)
                throw new ArgumentNullException("regexList");

            return AddIntent(intentName, new RegExLocaleMap(regexList));
        }

        public RegExpRecognizerMiddleware AddIntent(string intentName, RegExLocaleMap map)
        {
            if (string.IsNullOrWhiteSpace(intentName))
                throw new ArgumentNullException("intentName");

            if (_intents.ContainsKey(intentName))
                throw new ArgumentException($"RegExpRecognizer: an intent name '{intentName}' already exists.");

            _intents[intentName] = map;

            return this;
        }
        private List<Regex> GetExpressions(ITurnContext context, RegExLocaleMap map)
        {
            
            var locale = string.IsNullOrWhiteSpace(context.Activity.Locale) ? "*" : context.Activity.Locale;
            var entry = map.GetLocale(locale);
            return entry;
        }

        public static Intent Recognize(string text, Regex expression, double minScore)
        {
            return Recognize(text, expression, new List<string>(), minScore);
        }
        public static Intent Recognize(string text, Regex expression, List<string> entityTypes, double minScore)
        {
            // Note: Not throwing here, as users enter whitespace all the time. 
            if (string.IsNullOrWhiteSpace(text))
                return null;

            if (expression == null)
                throw new ArgumentNullException("expression");

            if (entityTypes == null)
                throw new ArgumentNullException("entity Types");

            if (minScore < 0 || minScore > 1.0)
                throw new ArgumentOutOfRangeException($"RegExpRecognizer: a minScore of '{minScore}' is out of range for expression '{expression.ToString()}'");

            var match = expression.Match(text);
            //var matches = expression.Matches(text);
            if (match.Success)
            {
                double coverage = (double)match.Length / (double)text.Length;
                double score = minScore + ((1.0 - minScore) * coverage);

                Intent intent = new Intent()
                {
                    Name = expression.ToString(),
                    Score = score
                };

                for (int i = 0; i < match.Groups.Count; i++)
                {
                    if (i == 0)
                        continue;   // First one is always the entire capture, so just skip

                    string groupName = DefaultEntityType;
                    if (entityTypes.Count > 0)
                    {
                        // If the dev passed in group names, use them. 
                        groupName = (i - 1) < entityTypes.Count ? entityTypes[i - 1] : DefaultEntityType;
                    }
                    else
                    {
                        groupName = expression.GroupNameFromNumber(i);
                        if (string.IsNullOrEmpty(groupName))
                        {
                            groupName = DefaultEntityType;
                        }
                    }

                    Group g = match.Groups[i];
                    if (g.Success)
                    {
                        Entity newEntity = new Entity()
                        {
                            GroupName = groupName,
                            Score = 1.0,
                            Value = match.Groups[i].Value
                        };
                        intent.Entities.Add(newEntity);
                    }
                }

                return intent;
            }

            return null;
        }
    }
}
