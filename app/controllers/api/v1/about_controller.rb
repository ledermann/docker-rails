module Api
  module V1
    class AboutController < ApiController
      def show
        render json: Rails.cache.fetch('versions') { versions }
      end

      private

      def versions
        {
          version:       Rails.application.version,
          build_time:    Rails.application.build_time,
          ruby:          Rails.application.ruby_version,
          rubygems:      Rails.application.rubygems_version,
          bundler:       Rails.application.bundler_version,
          rails:         Rails.application.rails_version,
          postgresql:    Rails.application.postgresql_version,
          redis:         Rails.application.redis_version,
          memcached:     Rails.application.memcached_version,
          elasticsearch: Rails.application.elasticsearch_version
        }
      end
    end
  end
end
