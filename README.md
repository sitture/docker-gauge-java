# sitture / docker-gauge-java

[![CircleCI](https://circleci.com/gh/sitture/docker-gauge-java.svg?style=shield)](https://circleci.com/gh/sitture/docker-gauge-java) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?maxAge=2592000)](https://opensource.org/licenses/MIT) [![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](../../issues) [![Docker Pulls](https://img.shields.io/docker/pulls/sitture/docker-gauge-java.svg?style=round-square)](https://hub.docker.com/r/sitture/docker-gauge-java) [![Docker Stars](https://img.shields.io/docker/stars/sitture/docker-gauge-java.svg)](https://hub.docker.com/r/sitture/docker-gauge-java)

[![Gauge Badge](https://gauge.org/Gauge_Badge.svg)](https://gauge.org/)

An alpine based docker maven image with [Gauge](https://gauge.org) from [ThoughtWorks](https://www.thoughtworks.com) installed for running BDD style [gauge-java](https://github.com/getgauge/gauge-java) test suites.

The docker image tagging is based on the [version of Gauge](https://github.com/getgauge/gauge/releases). E.g. The `sitture/docker-gauge-java:latest` tag will always contain the latest version of gauge and `sitture/docker-gauge-java:1.0.0` tag will contain version `1.0.0` of gauge.

Here are all the [supported tags](https://hub.docker.com/r/sitture/docker-gauge-java/tags/) of the image.

__Note:__ The current `latest` version of the image is built on top of `JDK 11`.

- Gauge [Latest](https://github.com/getgauge/gauge/releases)
    - Plugins `html-report, java, screenshot, spectacle, xml-report, reportserver, inprogress`
- Maven 3
- Additional tools: `bash, curl, wget, unzip, tar`

## Usage

Pull the latest Image with

```bash
docker pull sitture/docker-gauge-java:latest
```

Or you can build an image with remote Dockerfile:

```bash
docker build --progress=plain --pull \
	--build-arg BASE_IMAGE_TAG=21-jdk \
	--build-arg GAUGE_VERSION=1.6.4 \
	-t sitture/docker-gauge-java:latest \
  "github.com/sitture/docker-gauge-java.git#:eclipse-temurin"
```

### Using `docker run`

```bash
docker run -it --rm sitture/docker-gauge-java:latest gauge -v
```

When using maven, you can mount the maven `.m2` repository in the container:

```bash
docker run -it --rm -v ~/.m2:/root/.m2 sitture/docker-gauge-java:latest mvn --version
```

You can add additional volumes for your test reports, etc.

### Using `docker-compose.yml`

Example:

```yaml
services:
    gauge:
      image: sitture/docker-gauge-java:latest
      container_name: docker-gauge-java
      volumes:
        - '.:/usr/src/app'
        - '/Users/${USER}/.m2:/root/.m2'
      command: gauge -v
```

## Issues & Contributions

Please [open an issue here](../../issues) on GitHub if you have a problem, suggestion, or other comment.

Pull requests are welcome and encouraged! Any contributions should include new or updated unit tests as necessary to maintain thorough test coverage.
