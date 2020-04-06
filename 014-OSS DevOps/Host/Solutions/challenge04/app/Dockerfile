FROM python:alpine3.8

# Copy local directory "src" to container filesystem "/src"
COPY src /src

# Install Requirements server
RUN pip install -r /src/requirements.txt

EXPOSE 80

CMD ["python", "/src/main.py"]
