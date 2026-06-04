import os
from typing import Annotated

from agent_framework import Agent, tool
from agent_framework.foundry import FoundryChatClient
from agent_framework_foundry_hosting import ResponsesHostServer
from azure.identity import DefaultAzureCredential
from dotenv import load_dotenv
from pydantic import Field

load_dotenv()


# --- Weather data and tool ---

WEATHER_DATA = {'seattle': '55F, cloudy with light rain', 'new york': '72F, sunny with a few clouds', 'london': '60F, overcast with drizzle', 'tokyo': '80F, warm and humid', 'paris': '63F, clear skies'}


@tool(approval_mode="never_require")
def get_weather(
    location: Annotated[str, Field(description="The city or location to get weather for")]
) -> str:
    '''Get the current weather for a given location.'''
    result = WEATHER_DATA.get(location.lower(), f"65F, partly cloudy in {location}")
    return f"The weather in {location} is: {result}"



# --- Create the Foundry chat client ---

client = FoundryChatClient(
    project_endpoint=os.environ["FOUNDRY_PROJECT_ENDPOINT"],
    model=os.environ["AZURE_AI_MODEL_DEPLOYMENT_NAME"],
    credential=DefaultAzureCredential(),
)


# --- Create the agent ---

agent = Agent(
    client=client,
    instructions='You are a helpful weather assistant. When a user asks about the weather, use the get_weather tool to look up the current conditions. Always mention the location in your response and provide a concise, friendly summary. If the user asks about a location not in your data, provide the default conditions and let them know the data is simulated.',
    tools=[get_weather],
    default_options={"store": False},
)


# --- Start the hosted server ---

server = ResponsesHostServer(agent)
server.run()
