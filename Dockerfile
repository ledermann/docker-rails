FROM ruby:2.3.3

# Set time zone
ENV TZ=Europe/Berlin

# Install MySQL client
# Source: http://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/#repo-qg-apt-repo-manual-setup
RUN echo 'deb http://repo.mysql.com/apt/debian/ jessie mysql-5.7' > /etc/apt/sources.list.d/mysql.list && \
    apt-key adv --keyserver pgp.mit.edu --recv-keys 5072E1F5 && \
    apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y mysql-community-client && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Install Nginx
# Source: https://github.com/nginxinc/docker-nginx/blob/master/stable/jessie/Dockerfile
ENV NGINX_VERSION 1.10.2-1~jessie
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
  && echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list \
  && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
            ca-certificates \
            nginx=${NGINX_VERSION} \
            nginx-module-xslt \
            nginx-module-geoip \
            nginx-module-image-filter \
            nginx-module-perl \
            nginx-module-njs \
            gettext-base \
  && rm -rf /var/lib/apt/lists/*

# Add the nginx site and config
RUN rm -rf /etc/nginx/sites-available/default
ADD docker/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80 443

## Install Node.js
# Source: https://github.com/nodejs/docker-node/blob/master/6.9/wheezy/Dockerfile
RUN groupadd -r node && useradd -r -g node node

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 6.9.1

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

# Install wkhtmltopdf
RUN apt-get update && apt-get install -y libxrender1 libxext6 fonts-lato --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L#o wk.tar.xz http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && tar xf wk.tar.xz \
    && cp wkhtmltox/bin/wkhtmltopdf /usr/bin \
    && cp wkhtmltox/bin/wkhtmltoimage /usr/bin \
    && rm wk.tar.xz \
    && rm -r wkhtmltox
ADD docker/wkhtmltopdf/fontconfig.xml /etc/fonts/conf.d/10-wkhtmltopdf.conf

# Set some config
ENV RAILS_LOG_TO_STDOUT true

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Workdir
RUN mkdir -p /home/app
WORKDIR /home/app

# Save timestamp of image building
RUN date -u > BUILD_TIME

# Install gems
ADD Gemfile* /home/app/
RUN bundle install

# Add the Rails app
ADD . /home/app

# Precompile assets
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace

# Start up
CMD "docker/startup.sh"
