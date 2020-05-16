FROM golang:alpine

ENV TERRAFORM_VERSION=0.12.0

RUN apk add --update git bash openssh

ENV TF_DEV=true
ENV TF_RELEASE=true

WORKDIR $GOPATH/src/github.com/hashicorp/terraform
RUN git clone https://github.com/hashicorp/terraform.git ./ && \
    git checkout v${TERRAFORM_VERSION} && \
    /bin/bash scripts/build.sh

ADD . /go

WORKDIR $GOPATH
RUN chmod +x deploy.sh

CMD [ "/bin/sh" , "deploy.sh" ]