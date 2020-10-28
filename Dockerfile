FROM golang:1.14 as builder

COPY . /go/src/gin-demo
WORKDIR /go/src/gin-demo/src
RUN go env -w GOPROXY=https://goproxy.cn,direct\
    && go build -o gin-demo .

FROM alpine
WORKDIR /webapp
COPY --from=builder /go/src/gin-demo/src/gin-demo .
ENTRYPOINT ["/webapp/gin-demo"]
EXPOSE 80
