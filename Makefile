VERSION ?= "v1.0.1"
run:
	go run -ldflags="-X main.version=${VERSION} -X main.date=$(shell date '+%Y-%m-%dT%H:%M:%S%z')" src/main.go

all: prep binaries docker

prep:
	mkdir -p bin

binaries: linux64 darwin64

build:
	go build src/main.go

linux64:
	GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o bin/haproxy-agent64 ./src

darwin64:
	GOOS=darwin GOARCH=amd64 go build -ldflags="-s -w" -o bin/haproxy-agentOSX ./src

pack-linux64: linux64
	upx --brute bin/haproxy-agent64

pack-darwin64: darwin64
	upx --brute bin/haproxy-agentOSX

docker: pack-linux64
	docker build -t pasientskyhosting/haproxy-agent:latest . && \
	docker build -t pasientskyhosting/haproxy-agent:"$(VERSION)" .

docker-run:
	docker run pasientskyhosting/haproxy-agent:"$(VERSION)"

docker-push:
	docker push pasientskyhosting/haproxy-agent:"$(VERSION)"
