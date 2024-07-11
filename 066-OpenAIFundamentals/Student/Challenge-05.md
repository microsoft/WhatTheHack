# Challenge 05 - Responsible AI

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)**

## Pre-requisites

- AI Search Index implementation from Challenge 4
- Install required libraries in the `requirements.txt` file via `pip install -r requirements.txt` if you have not already.

## Introduction

As LLMs grow in popularity and use around the world, the need to manage and monitor their outputs becomes increasingly important. In this challenge, you will learn how to evaluate the outputs of LLMs and how to identify and mitigate potential biases in the model.

## Description

### Responsible AI on Azure 

More companies offer social features for user interaction in industries like gaming, social media, ecommerce and advertising, to build brand connection, promote trust and to drive digital engagement. However, this trend is accompanied by the growing concern of complex and inappropriate content online. These challenges have led to increasing regulatory pressures on enterprises worldwide for digital content safety and greater transparency in content moderation.

Azure AI Content Safety, a new Azure AI service and proof point in our Responsible AI journey will help businesses create safer online environments and communities. In Content Safety, models are designed to detect hate, violent, sexual and self-harm content across languages in images and text. The models assign a severity score to flagged content, indicating to human moderators what content requires urgent attention. 

### Harmful Content Detection (Azure Content Safety Studio)

Create a Content Safety resource in the Azure Portal or create a new one by logging in to the [Content Safety Studio](https://contentsafety.cognitive.azure.com/). Refer to this [table for region availability](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/overview#region-availability) to determine which region has the pertinent features for this activity.

In the Azure AI Content Safety Studio, you can customize settings for text and image moderation, assign severity scores, and test different scenarios. You can try out sample content or upload your own.
Here are detailed instructions on [getting started](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/studio-quickstart#prerequisites).

#### Student Task #1: Moderate image and text content

First, understand harm categories defined by Microsoft. 

Then, try out the following features in the Studio using provided sample text and data, or come up with your own examples. Analyze the moderation results. Try viewing the code!

* "Moderate text content"
* "Moderate image content"
* Try out the features on sample bulk data
  
What happens as you configure the threshold levels in the moderation features?

Are there any applications for content moderation in your line of work? What could they be?

Next, explore the "Monitor online activity" feature, which can be found on the homepage of the Content Safety Studio. How could this data be utilized in an existing application in your workflow, if at all?

##### Knowledge Check #1:
Check your understanding of the AI Content Safety Service by answering the following questions:

* True or False: The Text Moderation API is designed to support over 100 languages as input.
* True or False: The AI Content Safety Service has a feature to monitor activity statistics of your application.
* True or False: The Azure AI Content Safety Studio and the API have different risk scores (severity levels) across the categories of harm.

### Content Filtering and Protected Material Detection (Azure AI Studio)
Now that we've experimented with detecting harmful content in any given input, let's apply these principles to an LLM application.

You can configure a content filtering system both for user input (prompts) and LLM output (completions). 

#### Student Task #2: Create a custom content filter
Configure a content filter following these [instructions](https://learn.microsoft.com/en-us/azure/ai-studio/concepts/content-filtering#create-a-content-filter). Design a content filter that could hypothetically apply to an internal or external tool in your workplace. Or get creative and come up with a scenario that could use a filter, such as an online school forum.

In the "Input Filter" step, configure the four content categories. Keep "Prompt shields for jailbreak attacks" and "Prompt shields for indirect attacks" toggled to "Off" (default) for now.

In the "Output Filter" step, configure the four content categories. Keep "Protected material for text" and "Protected material for code" toggled to "Off" (default) for now.

Create a blocklist that will detect words with exact matching. 

Apply the content filter to one of your deployed models.

Test out the effectiveness of the content filter in the "Chat" with your model that has the new content filter.

##### Knowledge Check #2:
To assess your understanding of the concept of content filtering, answer the following questions based on the [documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/content-filter?tabs=warning%2Cpython-new):

* True or False: If you make a streaming completions request for multiple responses, the content filter will evaluate each response individually and return only the ones that pass.
* True or False: the finish_reason parameter will be returned on every response from the content filter.
* True or False: If the content filtering system is down, you will not be able to receive results about your request.


### PII Detection (Language Studio)

The importance of Personally Identifiable Information (PII) Detection in Generative AI applications is paramount, especially when handling one's own data. As these applications have the potential to process and generate vast amounts of text, the inadvertent inclusion of sensitive information can lead to significant privacy breaches. PII Detection systems ensure that any data that could potentially identify an individual is recognized and redacted before being shared or utilized, thereby upholding privacy standards and complying with data protection regulations. This is crucial in maintaining user trust and the integrity of AI-driven platforms.

#### Student Task #3: PII Detection, Redaction, and Extraction
Create a Language or Azure AI Services resource. Explore PII detection and extraction in the Azure Language Studio. [Try it out](https://language.cognitive.azure.com/tryout/pii).
* How do you enable redacting PII? How does the output hide those entities?
* How would you integrate this into an existing application? What would a conceptual architecture look like?
  
##### Knowledge Check #3: 
* True or False: The PII detection API will always return all PII entities.
* True or False: You can customize PII detection on Azure.
* True or False: PII detection is available only asynchronously.

### Groundedness, Prompt Shields, and other Safety Features

#### Groundedness
Learn what Ungroundedness and Groundedness are, as well as how Groundedness Detection works on the [Microsoft Technical Blog](https://techcommunity.microsoft.com/t5/ai-azure-ai-services-blog/detect-and-mitigate-ungrounded-model-outputs/ba-p/4099261).

#### Prompt Shields and Protected Material Detection
Protecting your LLM application from bad actors is equally important as moderating content. Doing so can secure your application to prevent data leakage. Read about the definitions of Jailbreak and Indirect 
Attacks, as well as implementing them on Azure, on the [Microsoft Technical blog](https://techcommunity.microsoft.com/t5/ai-azure-ai-services-blog/azure-ai-announces-prompt-shields-for-jailbreak-and-indirect/ba-p/4099140).

Attacks can occur through user prompts as well as documents that contain hidden embedded instructions to gain unauthorized control over the LLM session. Read more about [subtypes of user prompt attacks](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/concepts/jailbreak-detection). These are considered "input attacks."

#### Student Task #4: Update your custom content filter
Revisit the custom content filter you created earlier in the Azure AI Studio.

In the "Input filter," toggle the setting for "Prompt shields for jailbreak attacks" and "Prompt shields for indirect attacks" to either "Annotate only" or "Annotate and block." Keep in mind, for future implementations, that "Annotate and block" can reduce token usage compared to "Annotate only," which will still return the completed output.

Apply the updated filter to one of your deployed models.

In the "Chat" tab of the Playground in the Azure AI Studio, experiment with your updated content filter.

Here are some example jailbreak attacks to prompt your protected model:

## Success Criteria

To complete this challenge successfully, you should be able to:
- Articulate Responsible AI principles with OpenAI
- Demonstrate methods and approaches for evaluating LLMs
- Identify tools available to identify and mitigate harms in LLMs

## Additional Resources

- [Overview of Responsible AI practices for Azure OpenAI models](https://learn.microsoft.com/en-us/legal/cognitive-services/openai/overview)
- [Azure Cognitive Services - What is Content Filtering](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/concepts/content-filter)
- [Azure AI Content Safety tool](https://learn.microsoft.com/en-us/azure/cognitive-services/content-safety/overview)
- [Azure Content Safety Annotations feature](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/concepts/content-filter#annotations-preview)
- [OpenAI PII Detection Plugin](https://github.com/openai/chatgpt-retrieval-plugin/tree/main#plugins)
- [Hugging Face Evaluate Library](https://huggingface.co/docs/evaluate/index)
- [Question Answering Evaluation using LangChain](https://python.langchain.com/en/latest/use_cases/evaluation/qa_generation.html)
- [OpenAI Technical Whitepaper on evaluating models (see Section 3.1)](https://cdn.openai.com/papers/gpt-4-system-card.pdf)
- [Using GenAI Responsibly](https://learn.microsoft.com/en-us/shows/generative-ai-for-beginners/using-generative-ai-responsibly-generative-ai-for-beginners?WT.mc_id=academic-105485-koreyst)
- [Fundamentals of Responsible GenAI](https://learn.microsoft.com/en-us/training/modules/responsible-generative-ai/?WT.mc_id=academic-105485-koreyst)
- [New Updates in AI Content Safety](https://learn.microsoft.com/en-us/azure/ai-services/content-safety/whats-new)
- [eBook](https://aka.ms/contentsafetyebook)
