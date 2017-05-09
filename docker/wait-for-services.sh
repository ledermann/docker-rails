#! /bin/bash

# Wait for PostgreSQL
until curl $DB_HOST:5432 2>&1 | grep '52'; do
  echo 'Waiting for PostgreSQL...'
  sleep 1
done
echo "PostgreSQL is up and running"

# Wait for Elasticsearch
until $(curl --output /dev/null --silent --head --fail $ELASTICSEARCH_URL); do
  echo 'Waiting for Elasticsearch...'
  sleep 1
done
echo "Elasticsearch is up and running"
