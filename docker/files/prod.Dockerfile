FROM node:18-alpine As development

WORKDIR /usr/src/app

COPY --chown=node:node ./app/package*.json ./app/yarn.lock ./

RUN yarn

COPY --chown=node:node ./app/ ./

USER node

FROM node:18-alpine As build

WORKDIR /usr/src/app

COPY --chown=node:node /app/package*.json ./app/yarn.lock ./

COPY --chown=node:node --from=development /usr/src/app/node_modules ./node_modules

COPY --chown=node:node ./app/ ./

RUN yarn build

ENV NODE_ENV production

RUN yarn install --production --frozen-lockfile

USER node

FROM node:18-alpine As production

COPY --chown=node:node --from=build /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=build /usr/src/app/dist ./dist

CMD [ "node", "dist/main.js" ]
