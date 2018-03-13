module Api
  module V1
    class PostsController < ApiController
      def index
        @posts = if search_string
          Post.search_for(search_string, page: params[:page], per_page: 25)
        else
          Post.order(updated_at: :desc).page(params[:page]).per(25)
        end
      end

      def autocomplete
        @words = Post.autocomplete(search_string)
      end

      def show
        @post = Post.find(params[:id])
      end

      private

      helper_method def search_string
        params[:q].presence
      end
    end
  end
end
