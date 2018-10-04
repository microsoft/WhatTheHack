FROM node:alpine AS base
RUN apk -U add curl
WORKDIR /usr/src/app
EXPOSE 3000

FROM node:argon AS build
WORKDIR /usr/src/app

# Need bower to install client side packages
RUN npm install -g bower

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install

# Install client side app dependencies
COPY .bowerrc /usr/src/app
COPY bower.json /usr/src/app
RUN bower --allow-root install

# Bundle app source
COPY . /usr/src/app

FROM base as final
WORKDIR /usr/src/app
COPY --from=build /usr/src/app .
CMD [ "npm", "start" ]
