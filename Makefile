# XXX no versioning of the docker image
IMAGE_NAME=planitar/registrator

ifneq ($(NOCACHE),)
  NOCACHEFLAG=--no-cache
endif

.PHONY: build push clean test

build: bin/registrator
	docker build ${NOCACHEFLAG} -t ${IMAGE_NAME} .

push:
ifneq (${IMAGE_TAG},)
	docker tag -f ${IMAGE_NAME} ${IMAGE_NAME}:${IMAGE_TAG}
	docker push ${IMAGE_NAME}:${IMAGE_TAG}
else
	docker push ${IMAGE_NAME}
endif

clean:
	docker rmi -f ${IMAGE_NAME} || true
	rm -rf ./bin/

test:

bin/registrator:
	mkdir -p bin
	docker run --rm -v `pwd`/bin:/out planitar/dev-go /bin/bash -lc ' \
	  mkdir -p $$GOPATH/src/github.com/PlanitarInc && \
	  cd $$GOPATH/src/github.com/PlanitarInc && \
	  git clone https://github.com/PlanitarInc/registrator && \
	  cd registrator && \
	  git checkout stable && \
	  go get && go build && go test && \
	  cp $$GOPATH/bin/registrator /out; \
	'
