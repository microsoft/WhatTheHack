FROM node:16.5.0-alpine AS base
WORKDIR /usr/src/app

# FROM node:argon AS build
FROM node:16.5.0-alpine AS build
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install

# Bundle app source
COPY . /usr/src/app

FROM base as final
WORKDIR /usr/src/app
COPY --from=build /usr/src/app .
CMD [ "npm", "start" ]