# Build stage
FROM alpine:3.10.0 as builder
ENV GRAYLOG_URL_BASE https://packages.graylog2.org/releases/graylog
ENV GRAYLOG_VERSION 2.5.2
RUN apk add --no-cache bash curl
RUN mkdir -p /opt
WORKDIR /opt
RUN curl -s -S -L -O "${GRAYLOG_URL_BASE}/graylog-${GRAYLOG_VERSION}.tgz"
RUN curl -s -S -L -O "${GRAYLOG_URL_BASE}/graylog-${GRAYLOG_VERSION}.tgz.sha256.txt"
RUN sha256sum -c "graylog-${GRAYLOG_VERSION}.tgz.sha256.txt"
RUN tar -xzf "graylog-${GRAYLOG_VERSION}.tgz"
RUN mv "graylog-${GRAYLOG_VERSION}" graylog
RUN mkdir -p /opt/graylog/data/journal /opt/graylog/data/contentpacks /opt/graylog/config
COPY config /opt/graylog/config
COPY graylog.sh /opt/graylog/bin/graylog

# Run stage
FROM openjdk:8-jre-alpine
MAINTAINER Jochen Schalanda <jochen+docker@schalanda.name>
LABEL \
  org.label-schema.name="Graylog Alpine Docker Image" \
  org.label-schema.description="Graylog Docker image based on Alpine Linux and Azul Zulu OpenJDK" \
  org.label-schema.url="https://www.graylog.org/" \
  org.label-schema.usage="http://docs.graylog.org" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/joschi/docker-graylog-alpine" \
  org.label-schema.vendor="Jochen Schalanda" \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0" \
  com.microscaling.docker.dockerfile="/Dockerfile" \
  com.microscaling.license="MIT" \
  org.opencontainers.image.title="Graylog Alpine Docker Image" \
  org.opencontainers.image.description="Graylog Docker image based on Alpine Linux and Azul Zulu OpenJDK" \
  org.opencontainers.image.url="https://www.graylog.org/" \
  org.opencontainers.image.revision=$VCS_REF \
  org.opencontainers.image.source="https://github.com/joschi/docker-graylog-alpine" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.documentation="http://docs.graylog.org" \
  org.opencontainers.image.vendor="Jochen Schalanda" \
  org.opencontainers.image.version=$VERSION

ENV PATH /opt/graylog/bin:$PATH

# Build-time metadata as defined at http://label-schema.org and https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md
ARG VCS_REF
ARG VERSION

RUN \
  apk add --no-cache bash su-exec libcap && \
  addgroup -S graylog && \
  adduser -S -G graylog graylog && \
  setcap 'cap_net_bind_service=+ep' $(readlink -f /usr/bin/java)

COPY --from=builder --chown=graylog:graylog /opt/graylog /opt/graylog
COPY docker-entrypoint.sh /
# https://github.com/docker-library/openjdk/issues/77#issuecomment-302871030
COPY ld-musl-x86_64.path /etc/ld-musl-x86_64.path

VOLUME /opt/graylog/data

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9000

CMD ["graylog"]
