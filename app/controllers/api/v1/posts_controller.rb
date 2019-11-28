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

        render json: Panko::Response.new(
          meta: pagination_dict(posts),
          posts: Panko::ArraySerializer.new(posts, each_serializer: PostPreviewSerializer)
        )
      end

      def autocomplete
        words = Post.autocomplete(search_string)
        render json: words.to_json
      end

      def show
        render json: Panko::Response.new(
          post: PostSerializer.new.serialize(@post)
        )
      end

      def create
        @post = Post.new(post_params)
        authorize @post
        if @post.save
          render json: Panko::Response.new(
            post: PostSerializer.new.serialize(@post)
          ), status: :created, location: @post
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      def update
        authorize @post
        if @post.update(post_params)
          render json: Panko::Response.new(
            post: PostSerializer.new.serialize(@post)
          )
        else
          render json: @post.errors, status: :unprocessable_entity
        end
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
        @post = Post.friendly.find(params[:id])
      end

      def post_params
        params.require(:post).permit(
          :title, :content, :copyright, clips_attributes: [ :id, :image, :_destroy ]
        )
      end
    end
  end
end
