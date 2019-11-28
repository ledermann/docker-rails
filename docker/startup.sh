#! /bin/sh

./docker/wait-for-services.sh
./docker/prepare-db.sh
mkdir -p ./tmp/pids
bundle exec puma -C config/puma.rb
