module Api
  module V1
    class AuditsController < ApiController
      before_action :load_post

      def index
        render json: Panko::Response.new(
          audits: Panko::ArraySerializer.new(@post.audits.reorder(id: :desc), each_serializer: AuditSerializer)
        )
      end

      private

      def load_post
        @post = Post.friendly.find(params[:post_id])
      end
    end
  end
end
