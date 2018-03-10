class AuditsController < ApplicationController
  respond_to :html, :json

  def index
    respond_with audits
  end

  private

  helper_method def audits
    @audits ||= post.audits.reorder(id: :desc)
  end

  helper_method def post
    @post ||= Post.find(params[:post_id])
  end
end
