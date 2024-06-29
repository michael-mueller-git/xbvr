FROM node:18 AS builder1
WORKDIR /app
COPY . .
RUN cd ui && yarn install && yarn build


FROM golang:1.22 AS builder2
WORKDIR /app
COPY --from=builder1 /app /app
RUN CGO_ENABLED=1 go build -o xbvr


FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder2 /app/xbvr /usr/bin/xbvr

EXPOSE 9998-9999
VOLUME /root/.config/

CMD ["/usr/bin/xbvr"]
