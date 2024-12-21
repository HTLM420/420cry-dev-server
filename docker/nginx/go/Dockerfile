FROM nginx:1.27.0-alpine

COPY ./nginx/python/default.conf.template /etc/nginx/templates/

COPY ./build/certs/dotweb.test.crt ./build/certs/dotweb.test.key /etc/nginx/certs/

ENV NGINX_DOCUMENT_ROOT /app/public

WORKDIR /app
