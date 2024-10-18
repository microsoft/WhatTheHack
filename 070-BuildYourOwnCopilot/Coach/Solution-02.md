# Challenge 02 - Now We're Flying - Coach's Guide

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

[Watch the Train the Trainer video for Challenge 3](https://aka.ms/vsaia.hack.ttt.04)

### Create and load new data

1. Download the original data files from either `https://cosmosdbcosmicworks.blob.core.windows.net/cosmic-works-small/product.json` or `https://cosmosdbcosmicworks.blob.core.windows.net/cosmic-works-small/customer.json` to your local machine.
2. Create several new JSON objects based on the ones from the original data files.
3. Upload the new JSON objects to the Cosmos DB container using the Azure portal. Alternatively, you can use the [Cosmos DB Data Migration  Tool](https://github.com/AzureCosmosDB/data-migration-desktop-tool) to upload the data. For an example of how to use the tool, see the `Import-Data.ps1` in the repository (located in the `Scripts` folder).
4. Run the `VectorSearchAiAssistant.Service` project to vectorize and add the new items to the index. Running this project will initialize the Cosmos DB change feed handlers and start the vectorization process. The vectorization process will take a few minutes to complete.
5. Check the Cognitive Search index to validate the new items were added.
6. Ask questions about the new items that have been added.

### Experiment using prompts

1. Respond with a single number or with one or two words

`How many racking socks products do you have?`

`How many racing socks do you have? Respond with a single number.`

`How many racing socks do you have? Respond with a single number and nothing else.`

2. Respond with a bulleted lists or formatted a certain way

`Which products are for racing? Format the response as a JSON file.`

3. Respond using simpler syntax (e.g. explain it like I'm five)

`Describe the products you are selling`

`Describe the products you are selling like I am a five year old`

4. Challenge the model with prompts that require reasoning or chain of thought. For example, ask it to calculate aggregates on the data or go further and give some word problems like those you had in school.

`Which are the products categories that are available?`

`Which are the products categories that are available? Which category has the least products?`

`What is the average number of products per category of products?`

5. Challenge the model to explain its reasoning

`Which are the products categories that are available? Which category has the least products? Explain how you reached the conclusion.`

6. Request that the model list its sources

`Which are the product categories? Provide details on the sources of data you are using to answer.`
