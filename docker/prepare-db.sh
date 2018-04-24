#! /bin/sh

# If database exists, migrate. Otherweise create and seed
bundle exec rake db:migrate 2>/dev/null || bundle exec rake db:setup db:seed
echo "Done!"
