#! /bin/sh

# Wait for PostgreSQL
until nc -z -v -w30 $DB_HOST 5432
do
  echo 'Waiting for PostgreSQL...'
  sleep 1
done
echo "PostgreSQL is up and running"

# Wait for Elasticsearch
until nc -z -v -w30 $ELASTICSEARCH_HOST 9200
do
  echo 'Waiting for Elasticsearch...'
  sleep 1
done
echo "Elasticsearch is up and running"
