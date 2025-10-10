# Challenge 02 - OpenAI Models, Capabilities, and Model Router - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

There are 3 sections to Challenge-02: 
- Model Discovery
- Model Benchmarking
- Model Comparison
- Model Router

### Model Deployment

Students can use different/newer models than the ones listed in the student guide when this hack was published. Most models should work fine. 

If students use the automation script to deploy the models and populate the `.env` file values, the model names and versions to be deployed are specified in the [`main.bicepparam` file]((../Student/Resources/infra/main.bicepparam)) in the `/infra` folder of the Codespace/DevContainer. These values are listed in a JSON array in the parameter file. The first model in the array will be used to set the value of `CHAT_MODEL_NAME` in the `.env` file for use within the Jupyter Notebooks.

For Model Discovery and Model Benchmarking, the students will be comparing different models from the Model Catalog. The goal is for them to explore the model catalog and the model benchmarking tool. There is no right or wrong answer. Coaches should ask students which models look like a good pick for the task and why.

Some possible model choices include: 
1. GPT-4o Mini: Offers low latency and cost, making it ideal for real-time applications like chatbots or customer support. Multimodal support (text, image, audio), fast response times, and optimized for chaining multiple model calls.
2. Phi-4 Mini Instruct: Lightweight model with strong instruction-following and safety features. 128K token context length, fine-tuned for reasoning and safety adherence.

For Model Comparison, please navigate to [Github's Model Marketplace](https://github.com/marketplace/models). The students will be comparing different models through the [Github's Model Marketplace](https://github.com/marketplace/models) with various prompts. We are using Github models as it provides free access to AI LLM's for anyone with a Github account. This makes it very easy to get familiar and see the differences between the models without creating any Azure resources. 

Some possible model choices include: 
1. GPT-4o and GPT-4o Mini
2. GPT-4o and GPT-5 Mini

For Model Router, students will be deploying an instance of model router in AI Foundry and prompting it with different questions in the chat playground to see how the queries are automatically sent to the different LLMs in depending on their complexity.

The router may choose the model **`gpt-5-nano-2025-08-07`** consistently for the given prompts. This model is known for its ultra low latency and fast responses for simple tasks. Encourage students to try longer, multi-step reasoning prompts to trigger a different model.


<!--- 
The students will go through each section of this notebook in the `/Student/Resources/Notebooks` folder:
- [`CH-02-ModelComparison.ipynb`](../Student/Resources/Notebooks/CH-02-ModelComparison.ipynb)
  
The notebook above is filled with code cells. Students will run through these cells as they go through the exercises. 

In the `/Solutions` folder, you will see the same notebook but with the solutions:
- [`CH-02-ModelComparison-Solution.ipynb`](./Solutions/CH-02-ModelComparison-Solution.ipynb)

The cells display example outputs of what the students should see. Use this as a reference for the answers, although some outputs may vary slightly on the students' side. 

- Students can take CH1 as a reference for prompt engineering
- The model comparison chart does not have a specific correct answer. Students can put what they find in the chart.
- Coaches should ask students which model they would choose for each challenge and the reasons of choosing the model.
--->
