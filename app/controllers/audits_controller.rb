class AuditsController < ApplicationController
  def index
    @audits = post.audits.reorder(id: :desc)
    respond_with @audits
  end

  private

  helper_method def post
    @post ||= Post.find(params[:post_id])
  end
end
