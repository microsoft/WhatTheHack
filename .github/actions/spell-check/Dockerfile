FROM python:3.11-slim-bookworm
 
LABEL "com.github.actions.name"="WTH Spell Check Action"
LABEL "com.github.actions.description"="Check spelling of Markdown files in the WhatTheHack repo"
LABEL "com.github.actions.icon"="clipboard"
LABEL "com.github.actions.color"="green"
LABEL "repository"="https://github.com/microsoft/WhatTheHack"
LABEL "homepage"="https://github.com/microsoft/WhatTheHack"
 
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        aspell-en \
        hunspell \
        wget \
    && rm -rf /var/lib/apt/lists/*
 
RUN wget -q https://github.com/mikefarah/yq/releases/download/v4.43.1/yq_linux_amd64 -O /usr/local/bin/yq \
&& chmod +x /usr/local/bin/yq
 
RUN pip install --no-cache-dir \
    pymdown-extensions \
    pyspelling \
    pyyaml
 
COPY generate-spellcheck.py /generate-spellcheck.py
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
 
ENTRYPOINT ["/entrypoint.sh"]
