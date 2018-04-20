# Docker-Rails

[![Build Status](https://travis-ci.org/ledermann/docker-rails.svg?branch=master)](https://travis-ci.org/ledermann/docker-rails)
[![Code Climate](https://codeclimate.com/github/ledermann/docker-rails/badges/gpa.svg)](https://codeclimate.com/github/ledermann/docker-rails)
[![Issue Count](https://codeclimate.com/github/ledermann/docker-rails/badges/issue_count.svg)](https://codeclimate.com/github/ledermann/docker-rails)
[![Depfu](https://badges.depfu.com/badges/2f883bd05b4dca8448484ff9289ea15f/overview.svg)](https://depfu.com/github/ledermann/docker-rails)
[![Greenkeeper badge](https://badges.greenkeeper.io/ledermann/docker-rails.svg)](https://greenkeeper.io/)
[![](https://images.microbadger.com/badges/image/ledermann/docker-rails.svg)](https://microbadger.com/images/ledermann/docker-rails)

Simple Rails 5.2 application to demonstrate using Docker for production deployment. The application is a very simple kind of CMS (content management system) allowing to manage posts. Beside the boring [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) functionality it has some non-default features.


## Features

- Auto refresh via [ActionCable](https://github.com/rails/rails/tree/master/actioncable): If a displayed post gets changed by another user/instance, it refreshes automatically using the publish/subscribe pattern
- Full text search via [Elasticsearch](https://www.elastic.co/products/elasticsearch) and the [Searchkick](https://github.com/ankane/searchkick) gem to find post content (with suggestions)
- Autocompletion with [corejs-typeahead](https://github.com/corejavascript/typeahead.js)
- PDF export with [wkhtmltopdf](http://wkhtmltopdf.org/) and the [WickedPDF](https://github.com/mileszs/wicked_pdf) gem
- Editing HTML content with the WYSIWYG JavaScript editor [Trix](https://github.com/basecamp/trix)
- Uploading images directly to S3 with the [Shrine](https://github.com/janko-m/shrine) gem and [jQuery-File-Upload](https://github.com/blueimp/jQuery-File-Upload)
- Display images as Gallery with the [React Grid Gallery](https://github.com/benhowell/react-grid-gallery)
- Background jobs with [ActiveJob](https://github.com/rails/rails/tree/master/activejob) and the [Sidekiq](http://sidekiq.org/) gem (to handle full text indexing, image processing and ActionCable broadcasting)
- Cron scheduling with [Sidekiq-Cron](https://github.com/ondrejbartas/sidekiq-cron) to handle daily data updates from Wikipedia
- Permalinks using the [FriendlyId](https://github.com/norman/friendly_id) gem
- Infinitive scrolling (using the [Kaminari](https://github.com/kaminari/kaminari) gem and some JavaScript)
- User authentication with the [Clearance](https://github.com/thoughtbot/clearance/) gem
- Sending HTML e-mails with [Premailer](https://github.com/fphilipe/premailer-rails) and the [Really Simple Responsive HTML Email Template](https://github.com/leemunroe/responsive-html-email-template)
- Admin dashboards with [Blazer](https://github.com/ankane/blazer) gem
- Page specific JavaScript with [Punchbox](https://github.com/kieraneglin/punchbox)
- Bundle JavaScript libraries with [Yarn](https://yarnpkg.com)


## Why?

This repo demonstrates my way of building Rails applications. The techniques used to build the app should not be considered as "best practice", maybe there are better ways to build. Any [feedback](https://github.com/ledermann/docker-rails/issues/new) would be appreciated.


## Multi container architecture

The application is divided into 7 different containers:

- **app:** Main part. It contains the Rails code to handle web requests (by using the [Puma](https://github.com/puma/puma) gem). See the [Dockerfile](/Dockerfile) for details. The image is based on the Alpine variant of the official [Ruby image](https://hub.docker.com/_/ruby/) and uses multi-stage building to get a small image (~ 230MB download size).
- **worker:** Background processing. It contains the same Rails code, but only runs Sidekiq
- **db:** PostgreSQL database
- **elasticsearch:** Full text search engine
- **memcached:** Memory caching system (used from within the app via the [Dalli](https://github.com/petergoldstein/dalli) gem)
- **redis:** In-memory key/value store (used by Sidekiq and ActionCable)
- **backup:** Regularly backups the database as a dump via CRON to an Amazon S3 bucket

For running tests using RSpec, there are two additional containers:

- **test:** Application code prepared for running tests
- **selenium:** Standalone Chrome for executing system tests containing JavaScript

For testing there is a separate [Dockerfile.test](Dockerfile.test) and [docker-compose.test.yml](docker-compose.test.yml).

## Check it out!

To start up the application in your Docker environment:

```bash
git clone https://github.com/ledermann/docker-rails.git
cd docker-rails
cp .env.example .env
docker-compose up --build
```

Wait some minutes while the database will be prepared. Then,
navigate your browser to `http://[DOCKER_HOST]:[DOCKER_PORT]`.

Sign in to the admin account:

* Username: `admin@example.org`
* Password: `secret`

Enjoy!


## Deployment

On every push, the test suite (including [RuboCop](https://github.com/bbatsov/rubocop) checks) is run in public on [Travis CI](https://travis-ci.org/ledermann/docker-rails/builds) and in private on [Gitlab CI](https://about.gitlab.com/gitlab-ci/).

On every successful Travis build, a new Docker image is pushed to [Docker Hub](https://hub.docker.com/r/ledermann/docker-rails/).

On every start of the app container, the database will be migrated (or, if not exists, created with some seeds).


## Domain setup and SSL encryption with Let's Encrypt

The app container is ready to host with [nginx proxy](https://github.com/jwilder/nginx-proxy) and [letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion). See [docker-compose.production.yml](/docker-compose.production.yml) for example setup.
