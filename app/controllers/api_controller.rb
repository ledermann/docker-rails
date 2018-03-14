class ApiController < ActionController::Base
  include Knock::Authenticable

  before_action :set_default_format
  after_action :set_cors_header

  private

  def set_default_format
    request.format = :json
  end

  def set_cors_header
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization, User-Agent, Keep-Alive'
    headers['Access-Control-Request-Method'] = '*'
  end
end
