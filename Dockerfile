######################
# Stage: Builder
FROM ruby:2.4.4-alpine3.7 as Builder

RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    imagemagick \
    nodejs \
    yarn \
    tzdata

# Workdir
RUN mkdir -p /home/app
WORKDIR /home/app

# Install gems
ADD Gemfile* /home/app/
RUN bundle config --global frozen 1 && \
    bundle install --without development -j4 --retry 3

# Add the Rails app
ADD . /home/app

# Add user and chown folder
RUN addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app && \
    chown -R app:app /home/app
USER app

# Precompile assets
RUN RAILS_ENV=production SECRET_KEY_BASE=foo bundle exec rake assets:precompile --trace

###############################
# Stage wkhtmltopdf
FROM madnight/docker-alpine-wkhtmltopdf as wkhtmltopdf

###############################
# Stage Final
FROM ruby:2.4.4-alpine3.7
LABEL maintainer="mail@georg-ledermann.de"

RUN apk add --no-cache \
    imagemagick \
    nodejs \
    postgresql-dev \
    tzdata \
    curl \
    file \
    bash

# Copy wkhtmltopdf from former build stage
RUN apk add --update --no-cache \
    libgcc libstdc++ libx11 glib libxrender libxext libintl \
    libcrypto1.0 libssl1.0 \
    ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family
COPY --from=wkhtmltopdf /bin/wkhtmltopdf /bin/

RUN addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app
USER app

# Copy app with gems from former build stage
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder /home/app /home/app

# Set some config
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true
WORKDIR /home/app

# Expose Puma port
EXPOSE 3000

# Save timestamp of image building
RUN date -u > BUILD_TIME

# Start up
CMD ["docker/startup.sh"]
