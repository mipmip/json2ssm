.DEFAULT_GOAL := build

build:
	go build ./cmd/json2ssm

ci: install lint test

install:
	go get -u github.com/golang/dep/cmd/dep
	dep ensure
	go get -u gopkg.in/alecthomas/gometalinter.v2
	gometalinter.v2 --install
	go get github.com/axw/gocov/...
	go get github.com/mattn/goveralls
.PHONY: install

lint:
	gometalinter.v2 ./... | grep -v -E "(should have comment or be unexported|comment on exported method)" || true
	gometalinter.v2 ./... --errors
.PHONY: lint

test:
	go test -v ./...
	goveralls -service=travis-ci
.PHONY: test

release:
	goreleaser --rm-dist --config=.goreleaser.yml
.PHONY: release
