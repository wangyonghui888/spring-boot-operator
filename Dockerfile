# Build the manager binary
FROM golang:1.14.1 as builder

WORKDIR /workspace
COPY . .
#ENV GOPROXY=https://goproxy.io
# Copy the Go Modules manifests
#COPY go.mod go.mod
#COPY go.sum go.sum
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
#RUN export GOPROXY=https://goproxy.io && go mod download

# Copy the go source
#COPY main.go main.go
#COPY api/ api/
#COPY controllers/ controllers/

# Build
#RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o manager main.go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o manager main.go
# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM registry.cn-shanghai.aliyuncs.com/qingmuio/distroless_static:nonroot
WORKDIR /
COPY --from=builder /workspace/manager .
USER nonroot:nonroot

ENTRYPOINT ["/manager"]