FROM golang:1.20-alpine as builder

COPY build/setup-user.sh /usr/local/sbin/setup-user.sh

# Add R&D development root certificate so we can create trusted connections to our local development environment
COPY ./build/certs/420Cry_DevelopmentRootCA.crt /usr/local/share/ca-certificates/
RUN update-ca-certificates

# Copy some helper scripts
COPY ./build/development-domains/* /usr/local/bin/

COPY ./build/certs/420cry.test.crt ./build/certs/420cry.test.key /etc/nginx/certs/

# Switch to the user under which the container will run
USER $USER_NAME

WORKDIR /app

CMD /usr/local/bin/setup-development-domains.sh