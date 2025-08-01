FROM node:23.11.1-alpine3.21 AS builder
WORKDIR /opt/backend
COPY package.json ./
COPY *.js  ./
RUN npm install



FROM node:23.11.1-alpine3.21
RUN addgroup -S expense && adduser -S expense -G expense && \
    mkdir /opt/backend && \
    chown -R expense:expense /opt/backend
WORKDIR /opt/backend
ENV DB_HOST="mysql"
WORKDIR /opt/backend
USER expense
COPY --from=builder /opt/backend /opt/backend
CMD [ "node", "index.js" ]
