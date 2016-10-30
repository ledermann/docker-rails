#! /bin/bash

# Wait for MySQL
until $(curl --output /dev/null --silent --head --fail http://db:3306); do
  echo 'Waiting for MySQL...'
  sleep 1
done
echo "MySQL is up and running"

# Wait for Elasticsearch
until $(curl --output /dev/null --silent --head --fail http://elasticsearch:9200); do
  echo 'Waiting for Elasticsearch...'
  sleep 1
done
echo "Elasticsearch is up and running"
