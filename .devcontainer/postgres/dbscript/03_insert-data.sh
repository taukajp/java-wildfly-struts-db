#!/usr/bin/env bash

set -e

psql -U docker -d myappdb \
  -c "\copy item(name, price, created_at, updated_at) from '/docker-entrypoint-initdb.d/item_data.csv' delimiter ',' csv;"
