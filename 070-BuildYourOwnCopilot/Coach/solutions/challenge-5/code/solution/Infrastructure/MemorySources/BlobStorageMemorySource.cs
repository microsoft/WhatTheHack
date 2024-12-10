using Azure.Storage.Blobs;
using BuildYourOwnCopilot.Infrastructure.Interfaces;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;

namespace BuildYourOwnCopilot.Infrastructure.MemorySource
{
    public class BlobStorageMemorySource : IMemorySource
    {
        private readonly BlobStorageMemorySourceSettings _settings;
        private readonly ITextSplitterService _textSplitterService;
        private readonly ILogger _logger;

        private BlobStorageMemorySourceConfig _config;

        private readonly BlobServiceClient _blobServiceClient;
        private readonly Dictionary<string, BlobContainerClient> _containerClients;

        public BlobStorageMemorySource(
            IOptions<BlobStorageMemorySourceSettings> settings,
            ITextSplitterService textSplitterService,
            ILogger<BlobStorageMemorySource> logger)
        {
            _settings = settings.Value;
            _textSplitterService = textSplitterService;
            _logger = logger;

            _blobServiceClient = new BlobServiceClient(_settings.ConfigBlobStorageConnection);
            _containerClients = new Dictionary<string, BlobContainerClient>();
        }

        public async Task<List<string>> GetMemories()
        {
            await EnsureConfig();

            var filesContent = await Task.WhenAll(_config.TextFileMemorySources
                .Select(tfms => tfms.TextFiles.Select(tf => ReadTextFileContent(tfms.ContainerName, tf)))
                .SelectMany(x => x));

            var chunkedFilesContent = filesContent
                .Select(txt => txt.SplitIntoChunks ? _textSplitterService.SplitPlainText(txt.Content).TextChunks : new List<string>() { txt.Content })
                .SelectMany(x => x).ToList();

            return chunkedFilesContent;
        }

        private async Task EnsureConfig()
        {
            if (_config == null)
            {
                var configContent = await ReadConfigContent(_settings.ConfigBlobStorageContainer, _settings.ConfigFilePath);
                _config = JsonConvert.DeserializeObject<BlobStorageMemorySourceConfig>(configContent);
            }
        }

        private BlobContainerClient GetBlobContainerClient(string containerName)
        {
            if (!_containerClients.ContainsKey(containerName))
            {
                var containerClient = _blobServiceClient.GetBlobContainerClient(containerName);
                _containerClients.Add(containerName, containerClient);
                return containerClient;
            }

            return _containerClients[containerName];
        }

        private async Task<string> ReadConfigContent(string containerName, string filePath)
        {
            var containerClient = GetBlobContainerClient(containerName);
            var blobClient = containerClient.GetBlobClient(filePath);
            var reader = new StreamReader(await blobClient.OpenReadAsync());
            return await reader.ReadToEndAsync();
        }

        private async Task<(string Content, bool SplitIntoChunks)> ReadTextFileContent(string containerName, TextFileMemorySourceFile file)
        {
            var containerClient = GetBlobContainerClient(containerName);
            var blobClient = containerClient.GetBlobClient(file.FileName);
            var reader = new StreamReader(await blobClient.OpenReadAsync());
            return (await reader.ReadToEndAsync(), file.SplitIntoChunks);
        }
    }
}
