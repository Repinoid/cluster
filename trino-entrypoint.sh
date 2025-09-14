#!/bin/bash
# Create the data directory and set permissions
mkdir -p /var/trino/data
chown -R trino:trino /var/trino/data

# Proceed with the original entrypoint
exec /usr/lib/trino/bin/launcher run --etc-dir /etc/trino "$@"
