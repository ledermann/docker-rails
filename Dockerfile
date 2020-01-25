FROM docker.pkg.github.com/ledermann/docker-rails-base/rails-base-builder:latest as Builder
FROM docker.pkg.github.com/ledermann/docker-rails-base/rails-base-final:latest
LABEL maintainer="georg@ledermann.dev"

# Add Alpine packages
RUN apk add imagemagick

USER app

# Start up
CMD ["docker/startup.sh"]
