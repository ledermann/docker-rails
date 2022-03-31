class ApiController < ActionController::API
  include Knock::Authenticable

  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_default_format
  before_action :set_paper_trail_whodunnit

  private

  def set_default_format
    request.format = :json
  end

  def pagination_dict(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end

  def user_not_authorized
    render status: :unauthorized
  end
end
