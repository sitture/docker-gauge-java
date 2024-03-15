default: docker_buildx docker_build docker_build_jdk17 docker_build_jdk21

PROJECT_USERNAME ?= sitture
PROJECT_REPONAME ?= docker-gauge-java
DOCKER_IMAGE = $(PROJECT_USERNAME)/$(PROJECT_REPONAME)
SHA1 ?= $$(git rev-parse --verify HEAD)
TAG ?= $$(git describe --tags `git rev-list --tags --max-count=1`)
JDK11_TAG = openjdk-11
JDK17_TAG = jdk-17
JDK21_TAG = jdk-21
REPORTPORTAL_LATEST_RELEASE = $$(curl --silent "https://api.github.com/repos/reportportal/agent-net-gauge/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

docker_buildx:
	@docker buildx create --use

docker_build:
	@docker buildx build --progress=plain \
	--file ${JDK11_TAG}/Dockerfile \
	--build-arg GAUGE_VERSION=$(TAG) \
	--build-arg GAUGE_REPORTPORTAL_VERSION=$(REPORTPORTAL_LATEST_RELEASE) \
	--platform linux/arm64,linux/amd64 \
	-t $(DOCKER_IMAGE):$(JDK11_TAG) \
	-t $(DOCKER_IMAGE):$(TAG)-$(JDK11_TAG) \
	-t $(DOCKER_IMAGE):latest .

docker_build_jdk17:
	@docker buildx build --progress=plain \
	--file eclipse-temurin/Dockerfile \
	--build-arg BASE_IMAGE_TAG=17-jdk \
	--build-arg GAUGE_VERSION=$(TAG) \
	--build-arg GAUGE_REPORTPORTAL_VERSION=$(REPORTPORTAL_LATEST_RELEASE) \
	--platform linux/arm64,linux/amd64 \
	-t $(DOCKER_IMAGE):$(TAG) \
	-t $(DOCKER_IMAGE):$(JDK17_TAG) \
	-t $(DOCKER_IMAGE):$(TAG)-$(JDK17_TAG) .

docker_build_jdk21:
	@docker buildx build --progress=plain \
	--file eclipse-temurin/Dockerfile \
	--build-arg BASE_IMAGE_TAG=21-jdk \
	--build-arg GAUGE_VERSION=$(TAG) \
	--build-arg GAUGE_REPORTPORTAL_VERSION=$(REPORTPORTAL_LATEST_RELEASE) \
	--platform linux/arm64,linux/amd64 \
	-t $(DOCKER_IMAGE):$(TAG) \
	-t $(DOCKER_IMAGE):$(JDK21_TAG) \
	-t $(DOCKER_IMAGE):$(TAG)-$(JDK21_TAG) .