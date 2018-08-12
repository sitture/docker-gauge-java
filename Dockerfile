FROM maven:3.5-jdk-8-alpine
MAINTAINER Haroon Sheikh <haroon@sitture.com>

# os updates
RUN apk update && \
  # install/update packages
  apk add --update \
    ca-certificates \
    bash \
    wget \
    curl \
    tar && \
  rm -rf /var/cache/apk/*

# install gauge
ARG GAUGE_VERSION
ENV GAUGE_VERSION $GAUGE_VERSION
ENV GAUGE_ARCHIVE gauge-$GAUGE_VERSION-linux.x86_64.zip

RUN wget -qnc "https://github.com/getgauge/gauge/releases/download/v$GAUGE_VERSION/$GAUGE_ARCHIVE" && \
  # example release url https://github.com/getgauge/gauge/releases/download/v1.0.0/gauge-1.0.0-linux.x86_64.zip
  unzip $GAUGE_ARCHIVE -d /usr/local/bin && \
  rm -rf $GAUGE_ARCHIVE && \
  # install gauge plugins
  gauge install java && \
  gauge install html-report && \
  gauge install xml-report && \
  gauge install spectacle && gauge -v

WORKDIR /usr/src/app
ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["bash"]