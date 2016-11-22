FROM ruby:2.3.3

# Install MySQL client and NodeJS
RUN apt-get update && apt-get install -y nodejs mysql-client --no-install-recommends

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

# Set time zone
ENV TZ=Europe/Berlin

# wkhtmltopdf
RUN apt-get update && apt-get install -y libxrender1 libxext6 fonts-lato --no-install-recommends && \
    curl -L#o wk.tar.xz http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz \
    && tar xf wk.tar.xz \
    && cp wkhtmltox/bin/wkhtmltopdf /usr/bin \
    && cp wkhtmltox/bin/wkhtmltoimage /usr/bin \
    && rm wk.tar.xz \
    && rm -r wkhtmltox
ADD docker/wkhtmltopdf/fontconfig.xml /etc/fonts/conf.d/10-wkhtmltopdf.conf

# Add the nginx site and config
RUN rm -rf /etc/nginx/sites-available/default
ADD docker/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80

# Set some config
ENV RAILS_LOG_TO_STDOUT true

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Install bundle of gems
RUN mkdir -p /home/app/webapp
WORKDIR /home/app/webapp
ADD Gemfile* /home/app/webapp/
RUN bundle install

# Add the Rails app
ADD . /home/app/webapp

# Precompile assets
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace

# Save timestamp of image building
RUN date -u > BUILD_TIME

# Start up
CMD "docker/startup.sh"
