FROM node:8.9.4
EXPOSE 3000

WORKDIR /app

COPY . .
RUN yarn install --production
CMD [ "node", "index.js" ]

