[![Build Status](https://travis-ci.org/ledermann/docker-rails.svg?branch=master)](https://travis-ci.org/ledermann/docker-rails)

# Docker-Rails

Simple Rails application to demonstrate using Docker for development and deployment.


## App features

- Simple CRUD
- Caching
- Fulltext search
- PDF export
- Background jobs with Sidekiq (to handle fulltext indexing)


## [Dockerfile](/Dockerfile)

- Based on [ledermann/base](https://hub.docker.com/r/ledermann/base/), which is based on the official [Ruby image](https://hub.docker.com/_/ruby/)
- Adds [wkhtmltopdf](http://wkhtmltopdf.org/) for generating PDF from HTML/CSS


## Dependencies

Linked from other containers:

- [mysql](https://hub.docker.com/_/mysql/)
- [schickling/mysql-backup-s3](https://hub.docker.com/r/schickling/mysql-backup-s3/)
- [elasticsearch](https://hub.docker.com/_/elasticsearch/)
- [redis](https://hub.docker.com/_/redis/)
- [memcached](https://hub.docker.com/_/memcached/)


## Development

- Running tests with TravisCi and GitlabCI on every push


## Deployment

- Auto build image on Docker Hub on every push
- Deploy to Docker Cloud (with autoredeploy)
- Periodic database backup to Amazon S3

[![Deploy to Docker Cloud](https://files.cloud.docker.com/images/deploy-to-dockercloud.svg)](https://cloud.docker.com/stack/deploy/?repo=https://github.com/ledermann/docker-rails)
