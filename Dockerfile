FROM ledermann/rails-base-builder:3.0.1-alpine as Builder

# Remove some files not needed in resulting image
RUN rm .browserslistrc babel.config.js package.json postcss.config.js yarn.lock

FROM ledermann/rails-base-final:3.0.1-alpine
LABEL maintainer="georg@ledermann.dev"

# Workaround for BuildKit to trigger Builder's ONBUILDs to finish
COPY --from=Builder /etc/alpine-release /tmp/dummy

# Add Alpine packages
RUN apk add --no-cache imagemagick

USER app

# Start up
CMD ["docker/startup.sh"]
