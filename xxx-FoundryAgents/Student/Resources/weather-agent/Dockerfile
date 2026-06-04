FROM python:3.12-slim

WORKDIR /app

COPY . user_agent/
WORKDIR /app/user_agent

RUN if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

EXPOSE 8088

CMD ["python", "main.py"]
