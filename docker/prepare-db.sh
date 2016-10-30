#! /bin/bash

# If database exists, migrate. Otherweise create and seed
rake db:migrate 2>/dev/null || rake db:setup db:seed
echo "Done!"
