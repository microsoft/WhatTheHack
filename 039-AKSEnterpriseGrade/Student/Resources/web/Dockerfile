FROM node:24-alpine

WORKDIR /app
ENV NODE_ENV=production PORT=8080

COPY server.js styles.css favicon.ico web.png ./

USER node
EXPOSE 8080
CMD ["node", "server.js"]
