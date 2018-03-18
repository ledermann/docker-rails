module Api
  module V1
    class PostsController < ApiController
      before_action :load_post, only: [:show, :update, :destroy]

      def index
        posts = if search_string
          Post.search_for(search_string, page: params[:page], per_page: 25)
        else
          Post.order(updated_at: :desc).page(params[:page]).per(25)
        end

        render json: posts,
               each_serializer: PostPreviewSerializer,
               search_string: search_string,
               meta: pagination_dict(posts),
               root: 'posts'
      end

      def autocomplete
        words = Post.autocomplete(search_string)
        render json: words.to_json
      end

      def show
        respond_with @post
      end

      def create
        @post = Post.new(post_params)
        authorize @post
        @post.save
        respond_with @post
      end

      def update
        authorize @post
        @post.update(post_params)
        respond_with @post
      end

      def destroy
        authorize @post
        @post.destroy!
      end

      private

      def search_string
        params[:q].presence
      end

      def load_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(
          :title, :content, :copyright, clips_attributes: [ :id, :image, :_destroy ]
        )
      end
    end
  end
end
