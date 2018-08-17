default: docker_build

DOCKER_IMAGE = $(CIRCLE_PROJECT_USERNAME)/$(CIRCLE_PROJECT_REPONAME)

docker_build:
	@docker build \
	--build-arg VERSION=$(CIRCLE_TAG) \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg GAUGE_VERSION=$(CIRCLE_TAG) \
	-t $(DOCKER_IMAGE):$(CIRCLE_SHA1) .

docker_push:
	# Tag image as latest and version
	docker tag $(DOCKER_IMAGE):$(CIRCLE_SHA1) $(DOCKER_IMAGE):latest
	docker tag $(DOCKER_IMAGE):$(CIRCLE_SHA1) $(DOCKER_IMAGE):$(CIRCLE_TAG)
	# Push images
	docker push $(DOCKER_IMAGE):latest
	docker push $(DOCKER_IMAGE):$(CIRCLE_TAG)

