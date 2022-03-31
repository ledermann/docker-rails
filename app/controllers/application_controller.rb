class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  before_action :set_paper_trail_whodunnit

  helper_method def title(value = nil)
    if value
      @title = value
    else
      @title
    end
  end

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referer || root_path)
  end
end
