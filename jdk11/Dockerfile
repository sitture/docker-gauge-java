FROM sitture/docker-gauge-java-base

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

RUN apk add --update openjdk11 && \
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/app
ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["bash"]
