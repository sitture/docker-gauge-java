FROM maven:3-jdk-11-slim
MAINTAINER Haroon Sheikh <haroon@sitture.com>

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL build-date=$BUILD_DATE \
      name="Docker Gauge Java" \
      description="An alpine based maven image with Gauge installed for running BDD style gauge-java test suites." \
      vcs-ref=$VCS_REF \
      vcs-url="https://github.com/sitture/docker-gauge-java" \
      version=$VERSION \
      schema-version="1.0"

# os updates
RUN apt-get update && \
  # install/update packages
  apt-get install -y \
    apt-utils \
    ca-certificates \
    bash \
    wget \
    curl \
    tar && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# install gauge
ARG GAUGE_VERSION
ENV GAUGE_VERSION $GAUGE_VERSION
ENV GAUGE_ARCHIVE gauge-$GAUGE_VERSION-linux.x86_64.zip
ENV GAUGE_TELEMETRY_ENABLED false

RUN wget -qnc "https://github.com/getgauge/gauge/releases/download/v$GAUGE_VERSION/$GAUGE_ARCHIVE" && \
  # example release url https://github.com/getgauge/gauge/releases/download/v1.0.0/gauge-1.0.0-linux.x86_64.zip
  unzip $GAUGE_ARCHIVE -d /usr/local/bin && \
  rm -rf $GAUGE_ARCHIVE && \
  # do not check for updates
  gauge config check_updates false && \
  # install gauge plugins
  gauge install java && \
  gauge install html-report --version 4.0.6 && \
  gauge install xml-report && \
  gauge install spectacle && \
  gauge install screenshot && gauge -v

WORKDIR /usr/src/app
ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["bash"]
