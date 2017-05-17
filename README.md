# Docker-Rails

[![Build Status](https://travis-ci.org/ledermann/docker-rails.svg?branch=master)](https://travis-ci.org/ledermann/docker-rails)
[![Code Climate](https://codeclimate.com/github/ledermann/docker-rails/badges/gpa.svg)](https://codeclimate.com/github/ledermann/docker-rails)
[![Dependency Status](https://gemnasium.com/badges/github.com/ledermann/docker-rails.svg)](https://gemnasium.com/github.com/ledermann/docker-rails)
[![Greenkeeper badge](https://badges.greenkeeper.io/ledermann/docker-rails.svg)](https://greenkeeper.io/)
[![](https://images.microbadger.com/badges/image/ledermann/docker-rails.svg)](https://microbadger.com/images/ledermann/docker-rails)

Simple Rails 5.1 application to demonstrate using Docker for production deployment. The application is a very simple kind of CMS (content management system) allowing to manage posts. Beside the boring [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) functionality it demonstrates the following features:

- Auto refresh via [ActionCable](https://github.com/rails/rails/tree/master/actioncable): If a displayed post gets changed by another user/instance, it refreshes automatically using the publish/subscribe pattern
- Full text search via [Elasticsearch](https://www.elastic.co/products/elasticsearch) and the [Searchkick](https://github.com/ankane/searchkick) gem to find post content
- Background jobs with [ActiveJob](https://github.com/rails/rails/tree/master/activejob) and the [Sidekiq](http://sidekiq.org/) gem (to handle full text indexing)
- PDF export with [wkhtmltopdf](http://wkhtmltopdf.org/) and the [WickedPDF](https://github.com/mileszs/wicked_pdf) gem
- Infinitive scrolling (using the [Kaminari](https://github.com/kaminari/kaminari) gem and some JavaScript)
- Controller specific JavaScript embedded into the asset pipeline
- Bundle JavaScript libraries with [Yarn](https://yarnpkg.com)

The techniques used to build this app should not be considered as "best practice", maybe there are better ways to build. The repo demonstrates my way of building Rails applications. Any [feedback](https://github.com/ledermann/docker-rails/issues/new) would be appreciated.


## Multi container architecture

The application is divided into 7 different containers:

- **app:** Main part. It contains the Rails code to handle web requests (with the help of [Nginx](http://nginx.org) and the [Puma](https://github.com/puma/puma) gem). See the [Dockerfile](/Dockerfile) for details. The image is based on [ledermann/base](https://hub.docker.com/r/ledermann/base/), which in turn is based on the official [Ruby image](https://hub.docker.com/_/ruby/) and just adds Nginx, Node.js and Yarn.
- **worker:** Background processing. It contains the same Rails code, but only runs Sidekiq
- **db:** PostgreSQL database
- **elasticsearch:** Full text search engine
- **memcached:** Memory caching system (used from within the app via the [Dalli](https://github.com/petergoldstein/dalli) gem)
- **redis:** In-memory key/value store (used by Sidekiq and ActionCable)
- **backup:** Regularly backups the database as a dump via CRON to an Amazon S3 bucket

For running tests using RSpec, there are two additional containers:

- **test:** Application code prepared for running tests
- **selenium:** Standalone Chrome for executing feature specs containing JavaScript


## Check it out!

To start up the application in your Docker environment:

```bash
git clone https://github.com/ledermann/docker-rails.git
cd docker-rails
cp .env.example .env
docker-compose up --build
```

Navigate your browser to `http://[DOCKER_HOST]:[DOCKER_PORT]`.


## Deployment

On every push, the test suite is run in public on [TravisCi](https://travis-ci.org/ledermann/docker-rails/builds) and in private on [GitlabCI](https://about.gitlab.com/gitlab-ci/).

On every push, a new Docker image is built on [Docker Hub](https://hub.docker.com/r/ledermann/docker-rails/). Via its auto-deploy feature it can be deployed to your own cloud server.

On every start of the app container, the database will be migrated (or, if not exists, created with some seeds).

If you are already a Docker Cloud user, you can deploy the whole stack with one click:

[![Deploy to Docker Cloud](https://files.cloud.docker.com/images/deploy-to-dockercloud.svg)](https://cloud.docker.com/stack/deploy/?repo=https://github.com/ledermann/docker-rails)


## Domain setup and SSL encryption with Let's Encrypt

The app container is ready to host with [nginx proxy](https://github.com/jwilder/nginx-proxy) and [letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion). See [docker-cloud.yml](/docker-cloud.yml) for example setup.
