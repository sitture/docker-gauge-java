FROM alpine:latest

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL maintainer="Haroon Sheikh <haroon@sitture.com>" \
      build-date=$BUILD_DATE \
      name="Docker Gauge Java" \
      description="An alpine based maven image with Gauge installed for running BDD style gauge-java test suites." \
      vcs-ref=$VCS_REF \
      vcs-url="https://github.com/sitture/docker-gauge-java" \
      version=$VERSION \
      schema-version="1.0"

ENV LANG C.UTF-8

# OS updates & install dependencies
RUN set -ex && \
    # install/update packages
    apk update --no-cache && \
    apk add --no-cache --update \
        libc6-compat libstdc++ libintl \
        ca-certificates \
        bash \
        wget \
        curl \
        unzip \
        maven \
        tar && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2 && \
    rm -rf /var/cache/apk/*

# Configure maven
COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

RUN chmod +x /usr/local/bin/mvn-entrypoint.sh
ENV MAVEN_CONFIG "/root/.m2"

# Install gauge
ARG GAUGE_VERSION
ARG GAUGE_REPORTPORTAL_VERSION
ENV GAUGE_REPORTPORTAL_VERSION $GAUGE_REPORTPORTAL_VERSION
ENV GAUGE_REPORTPORTAL_ARCHIVE reportportal-$GAUGE_REPORTPORTAL_VERSION-linux-musl-x64.zip
ENV GAUGE_VERSION $GAUGE_VERSION
ENV GAUGE_ARCHIVE gauge-$GAUGE_VERSION-linux.x86_64.zip
ENV GAUGE_TELEMETRY_ENABLED false
RUN set -ex && \
    wget -qnc "https://github.com/getgauge/gauge/releases/download/v$GAUGE_VERSION/$GAUGE_ARCHIVE" && \
    # example release url https://github.com/getgauge/gauge/releases/download/v1.0.0/gauge-1.0.0-linux.x86_64.zip
    unzip $GAUGE_ARCHIVE -d /usr/local/bin && \
    rm -rf $GAUGE_ARCHIVE && \
    # do not check for updates
    gauge config check_updates false && \
    # install gauge plugins
    gauge install java && \
    gauge install html-report && \
    gauge install xml-report && \
    gauge install screenshot && \
    # Example reportportal download link https://github.com/reportportal/agent-net-gauge/releases/download/1.10.0/reportportal-1.10.0-linux-musl-x64.zip
    wget -qnc -O $GAUGE_REPORTPORTAL_ARCHIVE https://github.com/reportportal/agent-net-gauge/releases/download/$GAUGE_REPORTPORTAL_VERSION/$GAUGE_REPORTPORTAL_ARCHIVE && \
    gauge install reportportal --file $GAUGE_REPORTPORTAL_ARCHIVE && gauge -v && \
    rm -rf $GAUGE_REPORTPORTAL_ARCHIVE

WORKDIR /usr/src/app
ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["/bin/sh"]
