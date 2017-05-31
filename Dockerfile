# To keep this Dockerfile simple, we rely on `ledermann/base`,
# which is based on the official Ruby image and adds Nginx, Node.js and Yarn
FROM ledermann/base
LABEL maintainer="mail@georg-ledermann.de"

# Install PostgreSQL client and ImageMagick
RUN apt-get update && \
    apt-get install -y libpq-dev imagemagick && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Install wkhtmltopdf
RUN apt-get update && apt-get install -y libxrender1 libxext6 fonts-lato --no-install-recommends && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L#o wk.tar.xz https://downloads.wkhtmltopdf.org/0.12/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz \
    && tar xf wk.tar.xz \
    && cp wkhtmltox/bin/wkhtmltopdf /usr/bin \
    && cp wkhtmltox/bin/wkhtmltoimage /usr/bin \
    && rm wk.tar.xz \
    && rm -r wkhtmltox
ADD docker/wkhtmltopdf/fontconfig.xml /etc/fonts/conf.d/10-wkhtmltopdf.conf

# Set some config
ENV RAILS_LOG_TO_STDOUT true

# Workdir
RUN mkdir -p /home/app
WORKDIR /home/app

# Install gems
ADD Gemfile* /home/app/
ADD docker /home/app/docker/
RUN bash docker/bundle.sh

# Add the Rails app
ADD . /home/app

# Create user and group
RUN groupadd --gid 9999 app && \
    useradd --uid 9999 --gid app app && \
    chown -R app:app /home/app

# Precompile assets
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace

# Add the nginx site and config
RUN rm -rf /etc/nginx/sites-available/default
ADD docker/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80 443

# Save timestamp of image building
RUN date -u > BUILD_TIME

# Start up
CMD "docker/startup.sh"
