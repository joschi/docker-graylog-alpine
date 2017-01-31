#!/bin/bash

set -e

# Add "graylog" as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- graylog "$@"
fi

# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
if [ "$1" = 'graylog' -a "$(id -u)" = '0' ]; then
	# Change the ownership of user-mutable directories to elasticsearch
	for path in \
		/opt/graylog/data \
		/opt/graylog/config \
	; do
		chown -R graylog:graylog "$path"
	done
	
	set -- su-exec graylog "$@"
fi

# As argument is not related to Graylog,
# then assume that user wants to run their own process,
# for example a `bash` shell to explore this image
exec "$@"
