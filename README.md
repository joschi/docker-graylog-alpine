# Graylog

[![Docker Stars](https://img.shields.io/docker/stars/joschi/graylog-alpine.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/joschi/graylog-alpine.svg)][hub]
[![Image Size](https://images.microbadger.com/badges/image/joschi/graylog-alpine.svg)][microbadger]
[![Image Version](https://images.microbadger.com/badges/version/joschi/graylog-alpine.svg)][microbadger]
[![Image License](https://images.microbadger.com/badges/license/joschi/graylog-alpine.svg)][microbadger]


[hub]: https://hub.docker.com/r/joschi/graylog-alpine/
[microbadger]: https://microbadger.com/images/joschi/graylog-alpine

## What is Graylog?

Graylog is a centralized logging solution that allows the user to aggregate, process, and search logs.
It provides a powerful query language, a processing pipeline for data transformation, alerting capabilities, and much more.
It is fully extensible through a REST API and a plugin interface.
Plugins, content packs, and other add-ons can be downloaded from the [Graylog Marketplace](https://marketplace.graylog.org).


## Configuration

Every configuration setting of the [Graylog configuration file](https://github.com/Graylog2/graylog2-server/blob/2.4.1/misc/graylog.conf) can be set via environment variables by adding the `GRAYLOG_` prefix and using upper case.

Examples:

* `password_secret` &rarr; `GRAYLOG_PASSWORD_SECRET`
* `rest_listen_uri` &rarr; `GRAYLOG_REST_LISTEN_URI`

Alternatively the configuration file at [`/opt/graylog/config/graylog.conf`](config/graylog.conf) can be replaced by a customized version of this file.


## Mandatory settings

There are a few mandatory settings for this Docker image.

* `GRAYLOG_PASSWORD_SECRET`: A random string being used as password salt or nonce in different parts of Graylog.
* `GRAYLOG_ROOT_PASSWORD_SHA2`: The SHA-256 hash of the password of the "admin" user in Graylog, default: "admin".


### Environment variables (preferred)

This Docker image supports additional environment variables to configure different aspects of Graylog.

* `GRAYLOG_NODE_ID`: The Graylog node ID. If not provided, Graylog will generate one by itself and save it to `/opt/graylog/config/node-id`. This can be changed through the `GRAYLOG_NODE_ID_FILE` environment variable.
* `LOG4J`: Additional JVM parameters to [configure Log4j 2](https://logging.apache.org/log4j/2.x/manual/configuration.html), for example `-Dlog4j.configurationFile=/opt/graylog/conf/log4j2.xml` for providing a [custom Log4j 2 configuration file](config/log4j2.xml).
* `GRAYLOG_CONF`: Path to the [Graylog configuration file](config/graylog.conf).


### Graylog and Log4j 2 configuration files

This Docker image can optionally be configured by adding a custom Graylog configuration file to `/opt/graylog/config` or specifically overwrite [`/opt/graylog/config/graylog.conf`](config/graylog.conf) and [`/opt/graylog/config/log4j2.xml`](config/log4j2.xml).


## Persistent data

Graylog only writes data into two locations, which have to be persisted in Docker volumes to survive a container restart:

* `/opt/graylog/data/journal`: Path to the Graylog disk journal, can be configured with the [`GRAYLOG_MESSAGE_JOURNAL_DIR`](https://github.com/Graylog2/graylog2-server/blob/2.4.1/misc/graylog.conf#L415-L422) environment variable.
* `/opt/graylog/config/node-id`: The Graylog node ID file, necessary to persist if the `GRAYLOG_NODE_ID` environment variable is not being used.


## Caveats

Currently there's no support for binding to privileged ports (via [Linux kernel capabilities](https://docs.docker.com/engine/security/security/#/linux-kernel-capabilities)) due to the following issues:

* https://github.com/docker/docker/issues/8460
* https://github.com/docker-library/openjdk/issues/77


## License

This Docker image is licensed under the MIT license, see [LICENSE](LICENSE).
