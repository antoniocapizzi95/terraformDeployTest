FROM golang:1.18-alpine

WORKDIR /app

COPY .. .

ENV CGO_ENABLED=0
ENV GOOS=linux

RUN go build -o app

CMD ["./app"]