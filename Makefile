# Docker organization to pull the images from
ORG = blivens

# Name of image
IMAGE = gaviewer

# Docker TAG
TAG = latest

build:
	docker build \
		-t $(ORG)/$(IMAGE):$(TAG) \
		--build-arg IMAGE=$(ORG)/$(IMAGE):$(TAG) \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg VCS_URL=`git config --get remote.origin.url` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		.

push:
	docker push $(ORG)/$(IMAGE):$(TAG)

.PHONY: build push
