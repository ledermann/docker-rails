class AuditsController < ApplicationController
  def index
    @audits = post.audits.reorder(id: :desc)
  end

  private

  helper_method def post
    @post ||= Post.friendly.find(params[:post_id])
  end
end
