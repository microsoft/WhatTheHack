FROM python:3.9-slim-buster

LABEL "com.github.actions.name"="WTH Spell Check Action"
LABEL "com.github.actions.description"="Check spelling of Markdown files in the WhatTheHack repo"
LABEL "com.github.actions.icon"="clipboard"
LABEL "com.github.actions.color"="green"
LABEL "repository"="http://github.com/whatthehack"
LABEL "homepage"="http://github.com/actions"

RUN apt-get update \
  && apt-get install -y aspell hunspell wget

RUN wget https://github.com/mikefarah/yq/releases/download/v4.30.7/yq_linux_amd64 -O /usr/bin/yq && \
  chmod +x /usr/bin/yq

RUN pip3 install pymdown-extensions

RUN pip3 install pyspelling pyyaml

COPY generate-spellcheck.py /generate-spellcheck.py
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
