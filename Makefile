# XXX no versioning of the docker image
IMAGE_NAME=planitar/registrator

ifneq ($(NOCACHE),)
  NOCACHEFLAG=--no-cache
endif

.PHONY: build push clean test

build: bin/registrator
	docker build ${NOCACHEFLAG} -t ${IMAGE_NAME} .

push:
	docker push ${IMAGE_NAME}

clean:
	docker rmi -f ${IMAGE_NAME} || true
	rm -rf ./bin/

test:

bin/registrator:
	mkdir -p bin
	docker run --rm -v `pwd`/bin:/out planitar/dev-go /bin/bash -lc ' \
	  go get github.com/PlanitarInc/registrator && \
	  cd $$GOPATH/src/github.com/PlanitarInc/registrator && \
	  git checkout stable && \
	  go build && go test && \
	  cp $$GOPATH/bin/registrator /out; \
	'
