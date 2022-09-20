FROM node:16.5.0-alpine AS base
RUN apk -U add curl
WORKDIR /usr/src/app
EXPOSE 3001

# FROM node:argon AS build
FROM node:16.5.0-alpine AS build
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
#RUN npm init
RUN npm install npm@latest -g
RUN npm install

# Bundle app source
COPY . /usr/src/app

FROM base AS final
WORKDIR /usr/src/app
COPY --from=build /usr/src/app .
CMD [ "npm", "start" ]