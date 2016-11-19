FROM phusion/passenger-ruby23

# Upgrade the OS and Passenger in the image
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

# Install dependencies
RUN apt-get update && apt-get install -y nodejs mysql-client --no-install-recommends

# wkhtmltopdf
RUN apt-get update && apt-get install -y libxrender1 libxext6 fonts-lato --no-install-recommends && \
    curl -L#o wk.tar.xz http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && tar xf wk.tar.xz \
    && cp wkhtmltox/bin/wkhtmltopdf /usr/bin \
    && cp wkhtmltox/bin/wkhtmltoimage /usr/bin \
    && rm wk.tar.xz \
    && rm -r wkhtmltox
ADD docker/wkhtmltopdf/fontconfig.xml /etc/fonts/conf.d/10-wkhtmltopdf.conf

# Update Rubygems and Bundler
RUN gem update --system 2.6.8 && \
    gem install bundler -v 1.13.6

# Set correct environment variables.
ENV HOME=/root TZ=Europe/Berlin

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
ADD docker/wait-for-services.sh /etc/my_init.d/98-wait-for-services.sh
ADD docker/prepare-db.sh /etc/my_init.d/99-prepare-db.sh

# Enable Nginx
# Remove the default site
# Forward logs to stdout/stderr
RUN rm -f /etc/service/nginx/down && \
    rm /etc/nginx/sites-enabled/default && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

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
ADD Gemfile* /home/app/webapp/
RUN bundle install

# Add the Rails app
# Precompile assets
ADD . /home/app/webapp
RUN RAILS_ENV=production bin/rails assets:precompile

# Save timestamp of image building
# Set owner of app directory
RUN date -u > BUILD_TIME && \
    chown -R app:app /home/app

# Clean up APT and bundler when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
