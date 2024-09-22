ARG BASE_IMAGE_TAG
FROM eclipse-temurin:${BASE_IMAGE_TAG}

# Build-time metadata as defined at http://label-schema.org

ENV LANG=C.UTF-8
# OS updates & install dependencies
RUN set -ex && \
    # install/update packages
    apt-get update && apt-get install -y \
        apt-utils \
        ca-certificates \
        bash \
        wget \
        curl \
        unzip \
        maven \
        tar --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure maven
COPY build/mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY build/settings-docker.xml /usr/share/maven/ref/settings-docker.xml

RUN chmod +x /usr/local/bin/mvn-entrypoint.sh
ENV MAVEN_CONFIG="/root/.m2"

# Install gauge
COPY build/download_gauge.sh /download_gauge.sh
ARG GAUGE_VERSION
ENV GAUGE_VERSION=$GAUGE_VERSION
ENV GAUGE_TELEMETRY_ENABLED=false
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
    gauge install reportportal && gauge -v

WORKDIR /usr/src/app
ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["/bin/sh"]
