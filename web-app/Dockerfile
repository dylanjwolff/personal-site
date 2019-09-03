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

COPY makefile ./
COPY elm.json ./
RUN mkdir src
COPY src src

RUN make optimize

# -------------------------------------------------------------------------

FROM nginx:alpine

ENV WORKDIR /usr/share/nginx/html
ENV USER personal-site
RUN adduser -S -u 2000 -h /home/$USER $USER
RUN mkdir -p $WORKDIR
RUN chown $USER $WORKDIR

# USER $USER
WORKDIR $WORKDIR

COPY --from=builder build .

COPY nginx.conf /etc/nginx/nginx.conf
COPY personal-site.conf /etc/nginx/conf.d/personal-site.conf

RUN apk add certbot

CMD nginx -g 'daemon off;'
