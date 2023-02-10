FROM ghcr.io/ledermann/rails-base-builder:3.2.1-alpine as Builder

# Remove some files not needed in resulting image
RUN rm .browserslistrc babel.config.js package.json postcss.config.js

FROM ghcr.io/ledermann/rails-base-final:3.2.1-alpine
LABEL maintainer="georg@ledermann.dev"

# Workaround for BuildKit to trigger Builder's ONBUILDs to finish
COPY --from=Builder /etc/alpine-release /tmp/dummy

# Add Alpine packages
RUN apk add --no-cache imagemagick

USER app

# Enable YJIT
ENV RUBY_YJIT_ENABLE=1

# Start up
CMD ["docker/startup.sh"]
