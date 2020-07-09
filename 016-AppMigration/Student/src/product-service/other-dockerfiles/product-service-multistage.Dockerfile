FROM node:carbon as builder
COPY . /home/
RUN cd /home/ \
    && npm install

FROM node:carbon-alpine AS runtime
WORKDIR /home/
COPY --from=builder /home/ .
ENTRYPOINT npm start
