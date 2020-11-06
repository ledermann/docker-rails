class ErrorsController < ApplicationController
  def not_found
    logger.warn "Path not found: /#{params[:path]}"

    render file: 'public/404.html', layout: false, status: :not_found
  end
end
