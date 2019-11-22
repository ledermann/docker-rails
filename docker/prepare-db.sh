#! /bin/sh

# If database exists, migrate. Otherweise setup (create and seed)
bundle exec rake db:prepare && echo "Database is ready!"
