# Challenge 01 - Finding the kernel of truth

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

With the foundation of Semantic Kernel in place, your task in this challenge is to explore the use of plugins, vector memory, and Azure OpenAI services for chat completion. You’ll implement and extend the components needed to build an intelligent assistant that provides responses based on user questions and stored knowledge.

## Description

This challenge is intended to get you familiar with Semantic Kernel that is used extensively to implement this solution. There is no coding in this Challenge. Rather you are asked to read the articles below before going to Visual Studio and searching for the `Challenge 1` items. Here are the suggested readings that will help you address the tasks in the challenge:

- [Understanding the kernel](https://learn.microsoft.com/semantic-kernel/concepts/kernel?pivots=programming-language-csharp)
- [What is a Plugin?](https://learn.microsoft.com/semantic-kernel/concepts/plugins/?pivots=programming-language-csharp)
- [How to use function calling with Azure OpenAI Service](https://learn.microsoft.com/azure/ai-services/openai/how-to/function-calling)
- [What is a Planner?](https://learn.microsoft.com/semantic-kernel/concepts/planning?pivots=programming-language-csharp)
- [Embeddings](https://platform.openai.com/docs/guides/embeddings/use-cases)
- [Build Your Own Copilot with Azure Cosmos DB - Key Concepts](https://github.com/Azure/BuildYourOwnCopilot/blob/main/docs/concepts.md)

The remainder of this hackathon will be spent learning concepts and implementing them in Visual Studio writing code.

For each challenge, you can easily find the code snippets that you need to modify or add by searching for the challenge code in the code files. For example, to identify the code snippets for Challenge 1, search for `[Challenge 1]` in the code files.

In Visual Studio 2022, you can use the `Edit -> Find and Replace -> Find in Files` menu option of the `Ctrl + Shift + F` keyboard command to search for the challenge code. The result of the search will return multiple locations, each labeled as `// TODO: [Challenge X][Exercise X.E.T]` where `X` is the challenge number, `E` is the exercise number, and `T` is the task number.

![Search for Challenges](media/search-challenges.png)

> [!IMPORTANT]
> Within each challenge, we also recommend that you complete the exercises in the order they are presented. The exercises are designed to build on each other, and completing them in order will help you understand the solution accelerator better. Make sure you read the hints added as code comments to help you complete the tasks.

For some of the challenges we are also providing some open-ended exercises which do not have a specific solution. These exercises are designed to help you think about the solution accelerator and its components in a more creative way. We encourage you to complete these exercises at the end of the hackathon, after you have successfully completed all the challenges and their exercises.

For each challenge the recommended order of operations is the following:

1. Identify all the exercises for the challenge and read the hints provided in the code comments.
2. Attempt to tackle the exercises in the order they are presented. For each exercise, check the list of suggested readings to help you understand the concepts you need to apply (those lists are provided below for each challenge).
3. Take a note of any open-ended exercises and try to complete them at the end of the hackathon.

You may now go to the starter solution in Visual Studio and complete Challenge 1. Locate the exercises by searching for `// TODO: [Challenge 1]` as shown in the screenshot above. Then complete each exercise.

This challenge does not have open-ended exercises.

## Success Criteria

To successfully complete this challenge, you must:

- Demonstrate that the Semantic Kernel is properly configured and can make use of Azure OpenAI chat completions.
- Show that the plugins are correctly imported and used by the kernel.
- Verify that both the vector memory store and Cosmos DB memory store are functional.
- Confirm that the text embeddings are correctly generated and aligned with the memory store.
- Test the assistant by interacting with it through the chat interface and verifying that it responds accurately using relevant knowledge.

## Tips

- Pay attention to the plugins in your solution—these are critical for the assistant's ability to retrieve and use knowledge.
- Review the Cosmos DB change feed setup to understand how changes are tracked and applied to the memory store.
- Ensure that the text embedding service aligns with the RAG pattern, as this will directly impact the quality of your assistant's responses.

#### Debug and run the solution

This solution can be run locally or in GitHub Codespaces after the Azure deployment. To do so, use the steps below.

##### Configure local settings

- In the `UserPortal` project, make sure the content of the `appsettings.json` file is similar to this:

    ```json
    {
        "DetailedErrors": true,
        "Logging": {
            "LogLevel": {
            "Default": "Information",
            "Microsoft.AspNetCore": "Warning"
        }
        },
        "AllowedHosts": "*",
        "MSCosmosDBOpenAI": {
            "ChatManager": {
                "APIUrl": "https://localhost:63279",
                "APIRoutePrefix": ""
            }
        }
    }
    ```

- In the `ChatAPI` project, make sure the content of the `appsettings.json` file is similar to this:

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning",
      "Microsoft.SemanticKernel": "Error"
    },
    "ApplicationInsights": {
      "LogLevel": {
        "Default": "Information",
        "Microsoft.AspNetCore": "Warning",
        "Microsoft.SemanticKernel": "Error"
      }
    }
  },
  "AllowedHosts": "*",
  "MSCosmosDBOpenAI": {
    "ModelRegistryKnowledgeIndexing": {
      "customer-vector-store": {
        "Description":  "Provides content that can be used to build context around customers and sales orders. Includes information on customer properties like unique identifier, first name, last name, email address, phone number, address, and the count of sales orders. Also includes information on sales orders like customer unique identifier, order date, shipping date, and the list of product SKUs, names, prices and quantities.",
        "IndexName": "customer-vector-store",
        "VectorDataType": "float32",
        "Dimensions": 1536,
        "DistanceFunction": "cosine",
        "EmbeddingPath": "/embedding",
        "VectorIndexType": "quantizedFlat",
        "MaxVectorSearchResults": 10,
        "MinRelevance": 0.7
      },
      "product-vector-store": {
        "Description": "Provides content that can be used to build context around products. Includes information on product names, product details, product categories, product prices, product SKUs, and product tags.",
        "IndexName": "product-vector-store",
        "VectorDataType": "float32",
        "Dimensions": 1536,
        "DistanceFunction": "cosine",
        "EmbeddingPath": "/embedding",
        "VectorIndexType": "quantizedFlat",
        "MaxVectorSearchResults": 10,
        "MinRelevance": 0.7
      }
    },
    "StaticKnowledgeIndexing": {
      "Description": "Provides information on product return policies and product shipping policies.",
      "IndexName": "short-term",
      "Dimensions": 1536,
      "MaxVectorSearchResults": 10,
      "MinRelevance": 0.55
    },
    "SemanticCacheIndexing": {
      "Description": "Semantic cache.",
      "IndexName": "cache-vector-store",
      "VectorDataType": "float32",
      "Dimensions": 1536,
      "DistanceFunction": "cosine",
      "EmbeddingPath": "/embedding",
      "VectorIndexType": "quantizedFlat",
      "MaxVectorSearchResults": 1,
      "MinRelevance": 0.95
    },
    "SemanticCache": {
      "ConversationContextMaxTokens": 2000
    },
    "SystemCommandPlugins": [
      {
        "Name": "reset-semantic-cache",
        "Description": "Provides the capability to reset the semantic cache."
      },
      {
        "Name": "set-semantic-cache-similarity-score",
        "Description": "Provides the capability to set the similarity score used by the semantic cache.",
        "PromptName": "SystemCommands.SetSemanticCacheSimilarityScore"
      }
    ],
    "OpenAI": {
      "CompletionsDeployment": "completions",
      "CompletionsDeploymentMaxTokens": 8096,
      "EmbeddingsDeployment": "embeddings",
      "EmbeddingsDeploymentMaxTokens": 8191,
      "ChatCompletionPromptName": "RetailAssistant.Default",
      "ShortSummaryPromptName": "Summarizer.TwoWords",
      "ContextSelectorPromptName":  "ContextSelector.Default",
      "PromptOptimization": {
        "CompletionsMinTokens": 50,
        "CompletionsMaxTokens": 300,
        "SystemMaxTokens": 1500,
        "MemoryMinTokens": 1500,
        "MemoryMaxTokens": 7000,
        "MessagesMinTokens": 100,
        "MessagesMaxTokens": 200
      }
    },
    "TextSplitter": {
      "TokenizerEncoder": "cl100k_base",
      "ChunkSizeTokens": 500,
      "OverlapSizeTokens": 50
    },
    "CosmosDB": {
      "Containers": "completions, customer, product",
      "MonitoredContainers": "customer, product",
      "Database": "vsai-database",
      "ChangeFeedLeaseContainer": "leases"
    },
    "DurableSystemPrompt": {
      "BlobStorageContainer": "system-prompt"
    },
    "BlobStorageMemorySource": {
      "ConfigBlobStorageContainer": "memory-source",
      "ConfigFilePath": "BlobMemorySourceConfig.json"
    }
  }
}
```

- In the `ChatAPI` project, create an `appsettings.Development.json` file with the following content (replace all `<...>` placeholders with the values from your deployment):

```json
{
    "MSCosmosDBOpenAI": {
        "OpenAI": {
            "Endpoint": "https://<...>.openai.azure.com/",
            "Key": "<...>"
        },
        "CosmosDB": {
            "Endpoint": "https://<...>.documents.azure.com:443/",
            "Key": "<...>"
        },    
        "DurableSystemPrompt": {
            "BlobStorageConnection": "<...>"
        },
        "BlobStorageMemorySource": {
            "ConfigBlobStorageConnection": "<...>"
        }
    }
}
```

> [!NOTE]
> The `BlobStorageConnection` and `ConfigBlobStorageConnection` values can be found in the Azure Portal by navigating to the Storage Account created by the deployment (the one that has a container named `system-prompt`) and selecting the `Access keys` blade. The value is the `Connection string` for the `key1` key.

##### Running in Visual Studio Code

To run the solution using Visual Studio Code, perform the following steps:

Select the **Run and Debug** icon in the Activity Bar on the left-hand side of the window. This will open the Run and Debug view. Within the Run and Debug view, you will see a message similar to "To customize Run and Debug create a `launch.json` file." Select the link to create a `launch.json` file, which will open the `launch.json` file in the editor. When prompted to select a debugger, select the **`C#`** option. Replace the content of the file with the following configuration:

```json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "ChatAPI",
            "type": "dotnet",
            "request": "launch",
            "projectPath": "${workspaceFolder}/src/ChatAPI/ChatAPI.csproj"
        },
        {
            "name": "UserPortal",
            "type": "dotnet",
            "request": "launch",
            "projectPath": "${workspaceFolder}/src/UserPortal/UserPortal.csproj"
        }
    ],
    "compounds": [
        {
              "name": "API / Portal",
              "configurations": ["ChatAPI", "UserPortal"],
              "stopAll": true
        }
    ]
}
```

Save the `launch.json` configuration file.

You are now ready to start debugging the solution locally. To do this, select the **API / Portal** configuration from the dropdown list in the Run and Debug view, then press the green play button to start debugging. This will launch both the `ChatAPI` and `UserPortal` projects.

If you receive an untrusted certificate error, such as `System.Security.Authentication.AuthenticationException: The remote certificate is invalid because of errors in the certificate chain: UntrustedRoot`, you can resolve this by running the following command in the VS Code terminal:

```bash
dotnet dev-certs https --trust
```

If you want to run the solution in Visual Studio 2022+ instead, expand the section below and follow the debug instructions.

<details markdown=1>
<summary markdown="span"><strong>Click to expand/collapse Visual Studio 2022 debug instructions</strong></summary>

Before you can start debugging, you need to set the startup projects. To do this, right-click on the solution in the Solution Explorer and select `Configure Startup Projects...`. In the dialog that opens, select `Multiple startup projects` and set the `Action` for the `ChatAPI` and `UserPortal` projects to `Start`.

Also, make sure the newly created `appsettings.Development.json` file is copied to the output directory. To do this, right-click on the file in the Solution Explorer and select `Properties`. In the properties window, set the `Copy to Output Directory` property to `Copy always`.

You are now ready to start debugging the solution locally. To do this, press `F5` or select `Debug > Start Debugging` from the menu.

</details>
<br />

## Learning Resources

- [Azure Cosmos DB](https://learn.microsoft.com/azure/cosmos-db/)
- [Azure OpenAI service](https://learn.microsoft.com/azure/cognitive-services/openai/overview)
- [Understanding the kernel](https://learn.microsoft.com/semantic-kernel/concepts/kernel?pivots=programming-language-csharp)
- [What is a Plugin?](https://learn.microsoft.com/semantic-kernel/concepts/plugins/?pivots=programming-language-csharp)
- [How to use function calling with Azure OpenAI Service](https://learn.microsoft.com/azure/ai-services/openai/how-to/function-calling)
- [What is a Planner?](https://learn.microsoft.com/semantic-kernel/concepts/planning?pivots=programming-language-csharp)
- [Embeddings](https://platform.openai.com/docs/guides/embeddings/use-cases)
- [Build Your Own Copilot with Azure Cosmos DB - Key Concepts](https://github.com/Azure/BuildYourOwnCopilot/blob/main/docs/concepts.md)

## Advanced Challenges (Optional)

If you want to explore further, consider the following additional challenges:

- Explore the use of planners in Semantic Kernel and how they impact plugin selection and execution.
- Experiment with different text embeddings and observe their effect on the assistant's performance.
