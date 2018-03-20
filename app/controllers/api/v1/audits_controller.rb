module Api
  module V1
    class AuditsController < ApiController
      before_action :load_post

      def index
        render json: @post.audits.reorder(id: :desc)
      end

      private

      def load_post
        @post = Post.find(params[:post_id])
      end
    end
  end
end
