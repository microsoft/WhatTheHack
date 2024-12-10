using Microsoft.Extensions.Options;
using BuildYourOwnCopilot.Common.Models.Chat;
using Newtonsoft.Json;

namespace BuildYourOwnCopilot.Helpers
{
    public class ChatManager : IChatManager
    {
        /// <summary>
        /// All data is cached in the _sessions List object.
        /// </summary>
        private List<Session> _sessions = [];

        private readonly ChatManagerSettings _settings;
        private readonly HttpClient _httpClient;

        public ChatManager(
            IOptions<ChatManagerSettings> settings)
        {
            _settings = settings.Value;

            _httpClient = new HttpClient()
            {
                BaseAddress = new Uri(_settings.APIUrl)
            };
        }

        /// <summary>
        /// Returns list of chat session ids and names for left-hand nav to bind to (display Name and ChatSessionId as hidden)
        /// </summary>
        public async Task<List<Session>> GetAllChatSessionsAsync()
        {
            _sessions = await SendRequest<List<Session>>(HttpMethod.Get, "/sessions");

            return _sessions;
        }

        /// <summary>
        /// Returns the chat messages to display on the main web page when the user selects a chat from the left-hand nav
        /// </summary>
        public async Task<List<Message>> GetChatSessionMessagesAsync(string sessionId)
        {
            List<Message> chatMessages;

            if (_sessions.Count == 0)
            {
                return Enumerable.Empty<Message>().ToList();
            }

            var index = _sessions.FindIndex(s => s.SessionId == sessionId);

            chatMessages = await SendRequest<List<Message>>(HttpMethod.Get, $"/sessions/{sessionId}/messages");

            // Cache results
            _sessions[index].Messages = chatMessages;

            return chatMessages;
        }

        /// <summary>
        /// User creates a new Chat Session.
        /// </summary>
        public async Task CreateNewChatSessionAsync()
        {
            var session = await SendRequest<Session>(HttpMethod.Post, "/sessions");
            _sessions.Add(session);
        }

        /// <summary>
        /// Rename the Chat Ssssion from "New Chat" to the summary provided by OpenAI
        /// </summary>
        public async Task RenameChatSessionAsync(string sessionId, string newChatSessionName, bool onlyUpdateLocalSessionsCollection = false)
        {
            ArgumentNullException.ThrowIfNull(sessionId);

            var index = _sessions.FindIndex(s => s.SessionId == sessionId);
            _sessions[index].Name = newChatSessionName;

            if (!onlyUpdateLocalSessionsCollection)
            {
                await SendRequest<Session>(HttpMethod.Post,
                    $"/sessions/{sessionId}/rename?newChatSessionName={newChatSessionName}");
            }
        }

        /// <summary>
        /// User deletes a chat session
        /// </summary>
        public async Task DeleteChatSessionAsync(string sessionId)
        {
            ArgumentNullException.ThrowIfNull(sessionId);

            var index = _sessions.FindIndex(s => s.SessionId == sessionId);
            _sessions.RemoveAt(index);

            await SendRequest(HttpMethod.Delete, $"/sessions/{sessionId}");
        }

        /// <summary>
        /// Receive a prompt from a user, Vectorize it from _openAIService Get a completion from _openAiService
        /// </summary>
        public async Task<string> GetChatCompletionAsync(string sessionId, string userPrompt)
        {
            ArgumentNullException.ThrowIfNull(sessionId);

            var completion = await SendRequest<Completion>(HttpMethod.Post,
                $"/sessions/{sessionId}/completion", userPrompt);
            // Refresh the local messages cache:
            await GetChatSessionMessagesAsync(sessionId);
            return completion.Text;
        }

        public async Task<CompletionPrompt> GetCompletionPrompt(string sessionId, string completionPromptId)
        {
            ArgumentNullException.ThrowIfNullOrEmpty(sessionId);
            ArgumentNullException.ThrowIfNullOrEmpty(completionPromptId);

            var completionPrompt = await SendRequest<CompletionPrompt>(HttpMethod.Get,
                $"/sessions/{sessionId}/completionprompts/{completionPromptId}");
            return completionPrompt;
        }

        public async Task<string> SummarizeChatSessionNameAsync(string sessionId, string prompt)
        {
            ArgumentNullException.ThrowIfNull(sessionId);

            var response = await SendRequest<Completion>(HttpMethod.Post,
                $"/sessions/{sessionId}/summarize-name", prompt);

            await RenameChatSessionAsync(sessionId, response.Text, true);

            return response.Text;
        }

        /// <summary>
        /// Rate an assistant message. This can be used to discover useful AI responses for training, discoverability, and other benefits down the road.
        /// </summary>
        public async Task<Message> RateMessageAsync(string id, string sessionId, bool? rating)
        {
            ArgumentNullException.ThrowIfNull(id);
            ArgumentNullException.ThrowIfNull(sessionId);

            string url = rating == null 
                        ? $"/sessions/{sessionId}/message/{id}/rate" 
                        : $"/sessions/{sessionId}/message/{id}/rate?rating={rating}";

            return await SendRequest<Message>(HttpMethod.Post, url);
        }

        private async Task<T> SendRequest<T>(HttpMethod method, string requestUri, object payload = null)
        {
            HttpResponseMessage responseMessage = method switch
            {
                HttpMethod m when m == HttpMethod.Get => await _httpClient.GetAsync($"{_settings.APIRoutePrefix}{requestUri}"),
                HttpMethod m when m == HttpMethod.Post => await _httpClient.PostAsync($"{_settings.APIRoutePrefix}{requestUri}",
                                        payload == null ? null : JsonContent.Create(payload, payload.GetType())),
                _ => throw new NotImplementedException($"The Http method {method.Method} is not supported."),
            };
            var content = await responseMessage.Content.ReadAsStringAsync();
            return JsonConvert.DeserializeObject<T>(content);
        }

        private async Task SendRequest(HttpMethod method, string requestUri)
        {
            switch (method)
            {
                case HttpMethod m when m == HttpMethod.Delete:
                    await _httpClient.DeleteAsync($"{_settings.APIRoutePrefix}{requestUri}");
                    break;
                default:
                    throw new NotImplementedException($"The Http method {method.Method} is not supported.");
            }
        }
    }
}
