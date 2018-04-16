class ErrorsController < ApplicationController
  def error_404
    logger.warn "Path not found: /#{params[:path]}"

    render file: 'public/404.html', layout: false, status: :not_found
  end
end
