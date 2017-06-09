#! /bin/bash

# Avoid timeout while installing gems
# http://www.zhuwu.me/blog/posts/solve-gem-installation-timeout-when-building-docker-image

N=0
STATUS=1
until [ ${N} -ge 5 ]
do
  bundle install --without development --jobs 20 && STATUS=0 && break
  echo 'Try bundle again ...'
  N=$[${N}+1]
  sleep 1
done
exit ${STATUS}
