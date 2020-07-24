FROM node:carbon as builder

COPY . /home/
RUN cd /home/ \
    && npm install
WORKDIR /home/

ARG PRODUCT_SERVICE_BASE_URL
ENV PRODUCT_SERVICE_BASE_URL=$PRODUCT_SERVICE_BASE_URL
ARG INVENTORY_SERVICE_BASE_URL
ENV INVENTORY_SERVICE_BASE_URL=$INVENTORY_SERVICE_BASE_URL

RUN npm run build

FROM alpine:latest
RUN apk add --no-cache curl bash \
    && curl https://getcaddy.com | bash -s personal
WORKDIR /home/
COPY --from=builder /home/dist/ .
ENTRYPOINT caddy -port 80

