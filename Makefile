default: docker_buildx docker_build

CIRCLE_PROJECT_USERNAME ?= sitture
CIRCLE_PROJECT_REPONAME ?= docker-gauge-java
DOCKER_IMAGE = $(CIRCLE_PROJECT_USERNAME)/$(CIRCLE_PROJECT_REPONAME)
CIRCLE_SHA1 ?= $$(git rev-parse --verify HEAD)
CIRCLE_TAG ?= $$(git describe --tags `git rev-list --tags --max-count=1`)
JDK11_TAG = jdk-11
REPORTPORTAL_LATEST_RELEASE = $$(curl --silent "https://api.github.com/repos/reportportal/agent-net-gauge/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

docker_buildx:
	@docker buildx create --use

docker_build:
	@docker buildx build --progress=plain --pull \
	--build-arg VERSION=$(CIRCLE_TAG) \
	--build-arg VCS_REF=`git rev-parse --short HEAD` \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	--build-arg GAUGE_VERSION=$(CIRCLE_TAG) \
	--build-arg GAUGE_REPORTPORTAL_VERSION=$(REPORTPORTAL_LATEST_RELEASE) \
	--platform linux/arm64,linux/amd64 \
	-t $(DOCKER_IMAGE):$(CIRCLE_SHA1) \
	-t $(DOCKER_IMAGE):$(CIRCLE_TAG) \
	-t $(DOCKER_IMAGE):$(JDK11_TAG) \
	-t $(DOCKER_IMAGE):$(CIRCLE_TAG)-$(JDK11_TAG) \
	-t $(DOCKER_IMAGE):latest jdk11/

docker_push:
	# Push images
	docker push $(DOCKER_IMAGE):latest
	docker push $(DOCKER_IMAGE):$(CIRCLE_TAG)
	docker push $(DOCKER_IMAGE):$(JDK11_TAG)
	docker push $(DOCKER_IMAGE):$(CIRCLE_TAG)-$(JDK11_TAG)

notify:
	curl -X POST -I https://hooks.microbadger.com/images/sitture/docker-gauge-java/t32NLQBsxAjBB-Lv55qtHw4scTI=
