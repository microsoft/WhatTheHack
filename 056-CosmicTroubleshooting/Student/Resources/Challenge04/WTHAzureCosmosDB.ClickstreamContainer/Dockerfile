FROM python:3.7-slim

RUN mkdir /app
ADD ./code/clickstreamer.py /app
WORKDIR /app

RUN pip install azure-identity azure-keyvault-secrets azure.cosmos

CMD [ "python", "clickstreamer.py" ]