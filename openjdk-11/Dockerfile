FROM alpine:3.18.4

# Build-time metadata as defined at http://label-schema.org

ENV LANG C.UTF-8
# OS updates & install dependencies
RUN set -ex && \
    # install/update packages
    apk update --no-cache && \
    apk add --no-cache --update \
        krb5 \
        gcc musl-dev linux-headers \
        ca-certificates \
        bash \
        wget \
        curl \
        unzip \
        openjdk11 \
        maven \
        tar && \
    rm -rf /var/cache/apk/*

# Configure maven
COPY build/mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY build/settings-docker.xml /usr/share/maven/ref/settings-docker.xml

RUN chmod +x /usr/local/bin/mvn-entrypoint.sh
ENV MAVEN_CONFIG "/root/.m2"

# Install gauge
COPY build/download_gauge.sh /download_gauge.sh
ARG GAUGE_VERSION
ARG GAUGE_REPORTPORTAL_VERSION
ENV GAUGE_REPORTPORTAL_VERSION $GAUGE_REPORTPORTAL_VERSION
ENV GAUGE_REPORTPORTAL_ARCHIVE reportportal-$GAUGE_REPORTPORTAL_VERSION-linux-musl-x64.zip
ENV GAUGE_VERSION $GAUGE_VERSION
ENV GAUGE_ARCHIVE gauge-$GAUGE_VERSION-linux.x86_64.zip
ENV GAUGE_TELEMETRY_ENABLED false
RUN set -ex && pwd && \
    /download_gauge.sh --version=${GAUGE_VERSION} && \
    rm -rf download_gauge.sh && \
    # do not check for updates
    gauge config check_updates false && \
    # install gauge plugins
    gauge install java && \
    gauge install html-report && \
    gauge install xml-report && \
    gauge install screenshot && \
    gauge install reportserver && \
    gauge install inprogress && \
    # Example reportportal download link https://github.com/reportportal/agent-net-gauge/releases/download/1.10.0/reportportal-1.10.0-linux-musl-x64.zip
    wget -qnc -O $GAUGE_REPORTPORTAL_ARCHIVE https://github.com/reportportal/agent-net-gauge/releases/download/$GAUGE_REPORTPORTAL_VERSION/$GAUGE_REPORTPORTAL_ARCHIVE && \
    gauge install reportportal --file $GAUGE_REPORTPORTAL_ARCHIVE && gauge -v && \
    rm -rf $GAUGE_REPORTPORTAL_ARCHIVE

WORKDIR /usr/src/app
ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["/bin/sh"]
