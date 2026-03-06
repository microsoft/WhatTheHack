import os

from pydantic_ai.models.openai import OpenAIModelName, OpenAIChatModel

ai_foundry_model_name = os.getenv('AZURE_OPENAI_MODEL_NAME', 'gpt-4o-mini')

model_name: OpenAIModelName = ai_foundry_model_name

ai_foundry_model = OpenAIChatModel(model_name=model_name, provider='azure')