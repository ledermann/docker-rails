# https://ninjasandrobots.com/how-to-bust-your-rails-etag-cache-on-deployment
ENV["RAILS_CACHE_ID"] = Rails.application.build_time.to_i.to_s
