FROM ruby:2.3.1

# Install dependencies
RUN apt-get update && apt-get install -y build-essential nodejs mysql-client nginx

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

# Set some config
ENV RAILS_LOG_TO_STDOUT true

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

# Install bundle of gems
RUN mkdir -p /home/app/webapp
WORKDIR /home/app/webapp
COPY Gemfile* /home/app/webapp/
RUN bundle install

# Add the Rails app
ADD . /home/app/webapp

# Precompile assets
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace

# Save timestamp of image building
RUN date -u > BUILD_TIME

# Start up
CMD "docker/startup.sh"
