using Azure.Storage.Blobs;
using Microsoft.Extensions.Options;
using VectorSearchAiAssistant.SemanticKernel.Text;
using VectorSearchAiAssistant.Service.Interfaces;
using VectorSearchAiAssistant.Service.Models.ConfigurationOptions;

namespace VectorSearchAiAssistant.Service.Services
{
    public class DurableSystemPromptService : ISystemPromptService
    {
        readonly DurableSystemPromptServiceSettings _settings;
        readonly BlobContainerClient _storageClient;
        Dictionary<string, string> _prompts = new Dictionary<string, string>();

        public DurableSystemPromptService(
            IOptions<DurableSystemPromptServiceSettings> settings)
        {
            _settings = settings.Value;

            var blobServiceClient = new BlobServiceClient(_settings.BlobStorageConnection);
            _storageClient = blobServiceClient.GetBlobContainerClient(_settings.BlobStorageContainer);
        }

        public async Task<string> GetPrompt(string promptName, bool forceRefresh = false)
        {
            ArgumentNullException.ThrowIfNullOrEmpty(promptName, nameof(promptName));

            if (_prompts.ContainsKey(promptName) && !forceRefresh)
                return _prompts[promptName];

            var blobClient = _storageClient.GetBlobClient(GetFilePath(promptName));
            var reader = new StreamReader(await blobClient.OpenReadAsync());
            var prompt = await reader.ReadToEndAsync();

            _prompts[promptName] = prompt.NormalizeLineEndings();

            return prompt;
        }

        private string GetFilePath(string promptName)
        {
            var tokens = promptName.Split('.');

            var folderPath = (tokens.Length == 1 ? string.Empty : $"/{string.Join('/', tokens.Take(tokens.Length - 1))}");
            return $"{folderPath}/{tokens.Last()}.txt";
        }
    }
}
