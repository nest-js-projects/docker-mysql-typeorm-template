FROM node:18

WORKDIR /usr/src/app

COPY ./app/package*.json ./app/yarn.lock ./

RUN yarn

COPY ./app/ ./

EXPOSE 3000
