######################
# Stage: Builder
FROM ruby:2.6.3-alpine as Builder

ARG FOLDERS_TO_REMOVE
ARG BUNDLE_WITHOUT
ARG RAILS_ENV

ENV BUNDLE_WITHOUT ${BUNDLE_WITHOUT}
ENV RAILS_ENV ${RAILS_ENV}
ENV SECRET_KEY_BASE=foo
ENV RAILS_SERVE_STATIC_FILES=true

RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    git \
    imagemagick \
    nodejs \
    yarn \
    python2 \
    tzdata

WORKDIR /app

# Install gems
ADD Gemfile* /app/
RUN bundle config --global frozen 1 \
 && bundle install -j4 --retry 3 \
 # Remove unneeded files (cached *.gem, *.o, *.c)
 && rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete

# Install yarn packages
COPY package.json yarn.lock .yarnclean /app/
RUN yarn install

# Add the Rails app
ADD . /app

# Precompile assets
RUN bundle exec rake assets:precompile

# Remove folders not needed in resulting image
RUN rm -rf $FOLDERS_TO_REMOVE

###############################
# Stage Final
FROM ruby:2.6.3-alpine
LABEL maintainer="mail@georg-ledermann.de"

ARG ADDITIONAL_PACKAGES
ARG EXECJS_RUNTIME

# Add Alpine packages
RUN apk add --update --no-cache \
    postgresql-client \
    imagemagick \
    $ADDITIONAL_PACKAGES \
    tzdata \
    file

# Add user
RUN addgroup -g 1000 -S app \
 && adduser -u 1000 -S app -G app
USER app

# Copy app with gems from former build stage
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder --chown=app:app /app /app

# Set Rails env
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true
ENV EXECJS_RUNTIME $EXECJS_RUNTIME

WORKDIR /app

# Expose Puma port
EXPOSE 3000

# Save timestamp of image building
RUN date -u > BUILD_TIME

# Start up
CMD ["docker/startup.sh"]
