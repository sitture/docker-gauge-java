# sitture / docker-gauge-java

[![CircleCI](https://circleci.com/gh/sitture/docker-gauge-java.svg?style=shield)](https://circleci.com/gh/sitture/docker-gauge-java) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?maxAge=2592000)](https://opensource.org/licenses/MIT) [![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](../../issues)

An alpine based docker maven image with [Gauge](https://gauge.org) from [ThoughtWorks](https://www.thoughtworks.com) installed for running BDD style [gauge-java](https://github.com/getgauge/gauge-java) test suites.

The docker image tagging is based on the [version of Gauge](https://github.com/getgauge/gauge/releases). The `latest` tag contains the latest version of gauge.

## Usage

Pull the latest Image with

```bash
docker pull sitture/docker-gauge-java:latest
```

### Using `docker run`

```bash
docker run -it --rm sitture/docker-gauge-java:latest gauge -v
```

When using maven, you can mount the maven `.m2` repository in the container:

```bash
docker run -it --rm -v ~/.m2:/root/.m2 sitture/docker-gauge-java:latest mvn --version
```

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
