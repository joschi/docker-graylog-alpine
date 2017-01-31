# Graylog

[![Docker Stars](https://img.shields.io/docker/stars/joschi/graylog-alpine.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/joschi/graylog-alpine.svg)][hub]
[![Image Size](https://images.microbadger.com/badges/image/joschi/graylog-alpine.svg)](https://microbadger.com/images/joschi/graylog-alpine)
[![Image Version](https://images.microbadger.com/badges/version/joschi/graylog-alpine.svg)](https://microbadger.com/images/joschi/graylog-alpine)
[![Image License](https://images.microbadger.com/badges/license/joschi/graylog-alpine.svg)](https://microbadger.com/images/joschi/graylog-alpine)


[hub]: https://hub.docker.com/r/joschi/graylog-alpine/

## Caveats

Currently there's no support for binding to privileged ports (via [Linux kernel capabilities](https://docs.docker.com/engine/security/security/#/linux-kernel-capabilities)) due to the following issues:

* https://github.com/docker/docker/issues/8460
* https://github.com/docker-library/openjdk/issues/77
