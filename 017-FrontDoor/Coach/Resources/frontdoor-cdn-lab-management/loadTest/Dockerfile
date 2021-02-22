FROM loadimpact/k6
USER root
WORKDIR /app

ENV AZURE_STORAGE_ACCOUNT=
ENV REGION=
ENV WebSiteURL=


# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

RUN apk update 
RUN apk add bash
RUN apk add --virtual=build gcc libffi-dev musl-dev openssl-dev make python3-dev
RUN pip --no-cache-dir install -U pip
RUN pip --no-cache-dir install -I azure-cli
RUN apk del --purge build

COPY ./loadTest.js .
COPY ./runTest.sh .

ENTRYPOINT ["/bin/sh", "/app/runTest.sh"]