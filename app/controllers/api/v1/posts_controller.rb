module Api
  module V1
    class PostsController < ApiController
      def index
        posts = if search_string
          Post.search_for(search_string, page: params[:page], per_page: 25)
        else
          Post.order(updated_at: :desc).page(params[:page]).per(25)
        end

        render json: posts, each_serializer: PostPreviewSerializer, search_string: search_string, meta: pagination_dict(posts)
      end

      def autocomplete
        render json: Post.autocomplete(search_string)
      end

      def show
        render json: Post.find(params[:id])
      end

      private

      def search_string
        params[:q].presence
      end
    end
  end
end
