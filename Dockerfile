FROM library/haskell:8.0.2
RUN mkdir -p /app
WORKDIR /app
COPY ./bbn-json-hs-exe /app/bbn-json-hs-exe
ENTRYPOINT /app/bbn-json-hs-exe
