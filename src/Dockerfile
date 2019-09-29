FROM golang:1.12-alpine as builder

COPY . /go/src/gin-demo
WORKDIR /go/src/gin-demo/src
RUN GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOPROXY=https://goproxy.io go build -v -a -installsuffix cgo -o gin-demo .

FROM alpine
WORKDIR /webapp
COPY --from=builder /go/src/gin-demo/src/gin-demo .
ENTRYPOINT ["/webapp/gin-demo"]
EXPOSE 8080
