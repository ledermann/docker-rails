# Docker-Rails

Simple Rails 7.0 application to demonstrate using Docker for production deployment. The application is a very simple kind of CMS (content management system) allowing to manage posts. Beside the boring [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) functionality it has some non-default features.

This project aims to build a lean Docker image for use in production. Therefore it's based on the official Alpine Ruby image, uses multi-stage building and some [optimizations that I described in my blog](https://ledermann.dev/blog/2018/04/19/dockerize-rails-the-lean-way/). This results in an image size of ~80MB.


## Features

- Auto refresh via [ActionCable](https://github.com/rails/rails/tree/master/actioncable): If a displayed post gets changed by another user/instance, it refreshes automatically using the publish/subscribe pattern
- Full text search via [OpenSearch](https://opensearch.org/) and the [Searchkick](https://github.com/ankane/searchkick) gem to find post content (with suggestions)
- Autocompletion with [autocompleter](https://github.com/kraaden/autocomplete)
- Editing HTML content with the WYSIWYG JavaScript editor [Trix](https://github.com/basecamp/trix)
- Uploading images directly to S3 with the [Shrine](https://github.com/janko-m/shrine) gem and [jQuery-File-Upload](https://github.com/blueimp/jQuery-File-Upload)
- Background jobs with [ActiveJob](https://github.com/rails/rails/tree/master/activejob) and the [Sidekiq](http://sidekiq.org/) gem (to handle full text indexing, image processing and ActionCable broadcasting)
- Cron scheduling with [Sidekiq-Cron](https://github.com/ondrejbartas/sidekiq-cron) to handle daily data updates from Wikipedia
- Permalinks using the [FriendlyId](https://github.com/norman/friendly_id) gem
- Infinitive scrolling (using the [Kaminari](https://github.com/kaminari/kaminari) gem and some JavaScript)
- User authentication with the [Clearance](https://github.com/thoughtbot/clearance/) gem
- Sending HTML e-mails with [Premailer](https://github.com/fphilipe/premailer-rails) and the [Really Simple Responsive HTML Email Template](https://github.com/leemunroe/responsive-html-email-template)
- Admin dashboards with [Blazer](https://github.com/ankane/blazer) gem
- JavaScript with [Stimulus](https://stimulusjs.org/)
- Bundle JavaScript libraries with [Yarn](https://yarnpkg.com)


## Why?

This project demonstrates my way of building Rails applications. The techniques used to build the app should not be considered as "best practice", maybe there are better ways to build. Any [feedback](https://github.com/ledermann/docker-rails/issues/new) would be appreciated.


## Multi container architecture

There is an example **docker-compose.production.yml**. The whole stack is divided into multiple different containers:

- **app:** Main part. It contains the Rails code to handle web requests (by using the [Puma](https://github.com/puma/puma) gem). See the [Dockerfile](/Dockerfile) for details. The image is based on the Alpine variant of the official [Ruby image](https://hub.docker.com/_/ruby/) and uses multi-stage building.
- **worker:** Background processing. It contains the same Rails code, but only runs Sidekiq
- **db:** PostgreSQL database
- **opensearch:** Full text search engine
- **redis:** In-memory key/value store (used by Sidekiq, ActionCable and for caching)
- **backup:** Regularly backups the database as a dump via CRON to an Amazon S3 bucket

## Check it out!

To start up the application in your local Docker environment:

```bash
git clone https://github.com/ledermann/docker-rails.git
cd docker-rails
docker-compose build
docker-compose up
```

Wait some minutes while the database will be prepared by fetching articles from Wikipedia. Then,
navigate your browser to `http://[DOCKER_HOST]:[DOCKER_PORT]`.

Sign in to the admin account:

* Username: `admin@example.org`
* Password: `secret`

Enjoy!


## Tests / CI

On every push, the test suite (including [RuboCop](https://github.com/bbatsov/rubocop) checks) is performed via [GitHub Actions](https://github.com/ledermann/docker-rails/actions). If successful, a production image is built and pushed to GitHub Container Registry.


## Production deployment

The Docker image build includes precompiled assets only (no node_modules and no sources). The [spec folder](/spec) is removed and the Alpine packages for Node and Yarn are not installed.

The stack is ready to host with [traefik](https://traefik.io/) or [nginx proxy](https://github.com/jwilder/nginx-proxy) and [letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion).


## Demo

A demo installation is set up on [https://docker-rails.ledermann.dev](https://docker-rails.ledermann.dev).
