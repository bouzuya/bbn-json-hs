FROM fpco/stack-build:lts-8.13
RUN /usr/local/bin/stack setup
RUN mkdir -p /app
WORKDIR /app
ADD . /app
RUN /usr/local/bin/stack build
