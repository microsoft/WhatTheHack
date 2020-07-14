FROM node:10-alpine

ENV PORT 8000
EXPOSE 8000

RUN mkdir /app
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
CMD ["npm", "start"]
