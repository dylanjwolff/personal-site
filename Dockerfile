# Using multistage build for a clean, repeatable build environment
FROM node:alpine AS builder
RUN apk update
RUN apk add make

RUN npm install -g uglify-js

# Install Elm
RUN wget https://github.com/elm/compiler/releases/download/0.19.0/binary-for-linux-64-bit.gz
RUN gunzip -c binary-for-linux-64-bit.gz > elm
RUN mv elm /usr/bin/
RUN chmod a+x /usr/bin/elm

COPY web-app/makefile ./
COPY web-app/elm.json ./
RUN mkdir src
COPY web-app/src src

RUN make optimize

# -------------------------------------------------------------------------

FROM nginx:alpine

ENV WORKDIR /usr/share/nginx/html
RUN mkdir -p $WORKDIR

WORKDIR $WORKDIR

COPY --from=builder build .

COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY docker/nginx/personal-site.conf /etc/nginx/conf.d/personal-site.conf

RUN apk add certbot
RUN apk add apk-cron

WORKDIR /opt
COPY docker/entrypoint.sh .
CMD ./entrypoint.sh
