######################
# Stage: Builder
FROM docker.pkg.github.com/ledermann/docker-rails-base/rails-base-builder:latest as Builder

WORKDIR /app

ENV BUNDLE_WITHOUT=development:test
ENV RAILS_ENV=production
ENV SECRET_KEY_BASE=just-for-assets-compiling
ENV RAILS_SERVE_STATIC_FILES true

# Install gems
ADD Gemfile* /app/
RUN bundle install -j4 --retry 3 \
 && bundle clean --force \
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
RUN rm -rf node_modules tmp/cache vendor/bundle spec

###############################
# Stage Final
FROM docker.pkg.github.com/ledermann/docker-rails-base/rails-base-final:latest
LABEL maintainer="mail@georg-ledermann.de"

# Add Alpine packages
RUN apk add imagemagick

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

WORKDIR /app

# Expose Puma port
EXPOSE 3000

# Save timestamp of image building
RUN date -u > BUILD_TIME

# Start up
CMD ["docker/startup.sh"]
