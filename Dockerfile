FROM ledermann/rails-base-builder:latest as Builder
FROM ledermann/rails-base-final:latest
LABEL maintainer="georg@ledermann.dev"

# Add Alpine packages
RUN apk add imagemagick

USER app

# Start up
CMD ["docker/startup.sh"]
