FROM node:10.12.0-jessie as builder

ENV PRODUCT_SERVICE_BASE_URL '%%PRODUCT_SERVICE_BASE_URL%%'
ENV INVENTORY_SERVICE_BASE_URL '%%INVENTORY_SERVICE_BASE_URL%%'
ENV SKU_SERVICE_BASE_URL '%%INVENTORY_SERVICE_BASE_URL%%'
ENV DISPLAY_SQL_INFO '%%DISPLAY_SQL_INFO%%'
ENV APPINSIGHTS_INSTRUMENTATIONKEY '%%APPINSIGHTS_INSTRUMENTATIONKEY%%'

RUN mkdir /frontend
WORKDIR /frontend
COPY . .
RUN npm install && npm run build

FROM alpine:latest

EXPOSE 8080
ENV PORT 8080
ENV PRODUCT_SERVICE_BASE_URL http://localhost:8000
ENV INVENTORY_SERVICE_BASE_URL http://localhost:5000
ENV DISPLAY_SQL_INFO ""
ENV APPINSIGHTS_INSTRUMENTATIONKEY ""

RUN apk add --no-cache curl bash \
    && curl https://getcaddy.com | bash -s personal \
    && mkdir -p /app/dist
WORKDIR /app/
COPY --from=builder /frontend/dist/ ./dist/
COPY --from=builder /frontend/docker-startup.sh .
COPY --from=builder /frontend/Caddyfile .

CMD ./docker-startup.sh