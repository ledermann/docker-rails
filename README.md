[![Build Status](https://travis-ci.org/ledermann/docker-rails.svg?branch=master)](https://travis-ci.org/ledermann/docker-rails) [![](https://images.microbadger.com/badges/image/ledermann/docker-rails.svg)](https://microbadger.com/images/ledermann/docker-rails)
[![Dependency Status](https://gemnasium.com/badges/github.com/ledermann/docker-rails.svg)](https://gemnasium.com/github.com/ledermann/docker-rails)

# Docker-Rails

Simple Rails application to demonstrate using Docker for production deployment. The application is a very simple kind of CMS (content management system) allowing to manage pages. Beside the boring [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) functionality it demonstrates the following non-default features:

- Auto refresh via [ActionCable](https://github.com/rails/rails/tree/master/actioncable): If a displayed page gets changed by another user/instance, it refreshes automatically using the publish/subscribe pattern
- Full text search via [Elasticsearch](https://www.elastic.co/products/elasticsearch) to quickly find page content
- Background jobs with [ActiveJob](https://github.com/rails/rails/tree/master/activejob) and [Sidekiq](http://sidekiq.org/) (to handle full text indexing)
- PDF export with [wkhtmltopdf](http://wkhtmltopdf.org/) and the [PDFKit](https://github.com/pdfkit/pdfkit) gem

The technique used to build this app should not be considered as "best practice", maybe there are better ways to build. But it works for my needs. Any [feedback](https://github.com/ledermann/docker-rails/issues/new) would be appreciated.


## Multi-container architecture

The application is divided into 7 different containers:

- **app:** Main part. It contains the Rails code to handle web requests (with the help of [nginx](http://nginx.org) and the [Puma](https://github.com/puma/puma) gem)
- **worker:** Background processing. It contains the same Rails code, but only runs Sidekiq
- **db:** MySQL database
- **elasticsearch:** Full text search engine (used from within the app via the [Searchkick](https://github.com/ankane/searchkick) gem)
- **memcached:** Memory caching system (used from within the app via the [Dalli](https://github.com/petergoldstein/dalli) gem)
- **redis:** In-memory key/value store (used by Sidekiq and ActionCable)
- **backup:** Regularly backups the database as a dump via CRON to an Amazon S3 bucket

The image for the application and worker container is based on [ledermann/base](https://hub.docker.com/r/ledermann/base/), which in turn is based on the official [Ruby image](https://hub.docker.com/_/ruby/). See the [Dockerfile](/Dockerfile) for details.


## Test drive

To checkout the application in your Docker environment:

```bash
git clone https://github.com/ledermann/docker-rails.git
cd docker-rails
cp .env.example .env
docker-compose up --build
```

Navigate your browser to `http://[DOCKER_HOST]:[DOCKER_PORT]` to start it up.


## Development and Deployment

On every push, the (very small) test suite is run in public on [TravisCi](https://travis-ci.org/ledermann/docker-rails/builds) and in private on [GitlabCI](https://about.gitlab.com/gitlab-ci/)

On every push, a new Docker image is built on [Docker Hub](https://hub.docker.com/r/ledermann/docker-rails/). Via its auto-deploy feature it can be deployed to your own cloud server.

On every start of the app container, the database will be migrated (or, if not exists, created with some seeds)

If you are already a Docker Cloud user, you can deploy the whole stack with one click:

[![Deploy to Docker Cloud](https://files.cloud.docker.com/images/deploy-to-dockercloud.svg)](https://cloud.docker.com/stack/deploy/?repo=https://github.com/ledermann/docker-rails)


## Domain setup and SSL encryption with Let's Encrypt

The app container is ready to host with [nginx proxy](https://github.com/jwilder/nginx-proxy) and [letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion). See [docker-cloud.yml](/docker-cloud.yml) for example setup.
