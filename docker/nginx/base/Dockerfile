FROM nginx:1.27.3-alpine

COPY ./nginx/base/default.conf.template /etc/nginx/templates/

COPY ./build/certs/420cry.test.crt ./build/certs/420cry.test.key /etc/nginx/certs/

WORKDIR /app
