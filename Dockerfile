FROM node:9.4-alpine as builder
RUN apk update
RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base \
    git
# SSL self-signed certificate for localhost.
# RUN openssl genrsa -des3 -passout pass:x -out server.pass.key 2048 && \
#     openssl rsa -passin pass:x -in server.pass.key -out server.key && \
#     openssl req -new -key server.key -out server.csr -subj "/C=US/ST=California/L=California/O=localhost/OU=localhost/CN=localhost" && \
#     openssl x509 -req -sha256 -days 365 -in server.csr -signkey server.key -out server.crt

WORKDIR /etherwallet
ADD . /etherwallet
RUN npm install
RUN npm run dist


FROM nginx

COPY --from=builder  /etherwallet/dist /usr/share/nginx/html
# COPY --from=builder  /server.crt /opt/ssl/server.crt
# COPY --from=builder  /server.key /opt/ssl/server.key

EXPOSE 80
