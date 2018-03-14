module Api
  module V1
    class AuditsController < ApiController
      def index
        render json: post.audits.reorder(id: :desc)
      end

      private

      helper_method def post
        @post ||= Post.find(params[:post_id])
      end
    end
  end
end
