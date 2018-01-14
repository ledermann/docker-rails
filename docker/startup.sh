#! /bin/bash

./docker/wait-for-services.sh
./docker/prepare-db.sh
foreman start -f Procfile.production
