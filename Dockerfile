FROM phusion/passenger-ruby23

# Upgrade the OS and Passenger in the image
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# Install dependencies
RUN apt-get update && apt-get install -y wget nodejs mysql-client tnef imagemagick graphicsmagick poppler-utils poppler-data tesseract-ocr tesseract-ocr-deu --no-install-recommends && rm -rf /var/lib/apt/lists/*

# wkhtmltopdf
ARG WKHTMLTOPDF_VERSION=0.12.3
RUN wget http://download.gna.org/wkhtmltopdf/0.12/${WKHTMLTOPDF_VERSION}/wkhtmltox-${WKHTMLTOPDF_VERSION}_linux-generic-amd64.tar.xz \
    && tar xf wkhtmltox-${WKHTMLTOPDF_VERSION}_linux-generic-amd64.tar.xz \
    && cp wkhtmltox/bin/wkhtmltopdf /usr/bin \
    && cp wkhtmltox/bin/wkhtmltoimage /usr/bin \
    && rm wkhtmltox-${WKHTMLTOPDF_VERSION}_linux-generic-amd64.tar.xz \
    && rm -r wkhtmltox
RUN apt-get update && apt-get install fonts-lato
ADD docker/wkhtmltopdf/fontconfig.xml /etc/fonts/conf.d/10-wkhtmltopdf.conf

# Update Rubygems and Bundler
RUN gem update --system 2.6.8
RUN gem install bundler -v 1.13.6

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
ADD docker/wait-for-services.sh /etc/my_init.d/98-wait-for-services.sh
ADD docker/prepare-db.sh /etc/my_init.d/99-prepare-db.sh

# Enable Nginx / Passenger
RUN rm -f /etc/service/nginx/down

# Remove the default site
RUN rm /etc/nginx/sites-enabled/default

# Enable env vars
ADD docker/nginx/app-env.conf /etc/nginx/main.d/app-env.conf

# Add the nginx site and config
ADD docker/nginx/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD docker/nginx/webapp-http.conf /etc/nginx/conf.d/webapp-http.conf

# Set some config
ENV RAILS_LOG_TO_STDOUT true

# Install bundle of gems
RUN mkdir /home/app/webapp
WORKDIR /home/app/webapp
ADD Gemfile /home/app/webapp
ADD Gemfile.lock /home/app/webapp
RUN bundle install

# Add the Rails app
ADD . /home/app/webapp
RUN bundle exec rake assets:precompile

# Save timestamp of image building
RUN date -u +"%Y-%m-%d %H:%M" > BUILD_TIME

RUN chown -R app:app /home/app

# Clean up APT and bundler when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
