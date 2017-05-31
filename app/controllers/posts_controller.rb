class PostsController < ApplicationController
  respond_to :html, :json

  def index
    @posts = if search_string
      Post.elasticsearch search_string,
                         page:     params[:page],
                         per_page: 25
    else
      Post.order(updated_at: :desc).
        page(params[:page]).
        per(25)
    end
    authorize @posts

    respond_with @posts do |format|
      format.js { render 'kaminari/infinite-scrolling', locals: { objects: @posts } }
    end
  end

  def show
    @post = find_post
    authorize @post

    respond_with @post do |format|
      format.pdf do
        render pdf:          @post.title,
               disposition:  'inline',
               show_as_html: params[:debug].present?
      end
    end
  end

  def new
    @post = Post.new
    authorize @post
  end

  def edit
    @post = find_post
    authorize @post

    respond_with @post
  end

  def create
    @post = Post.new(post_params)
    authorize @post
    @post.save

    respond_with @post
  end

  def update
    @post = find_post
    authorize @post
    @post.update(post_params)

    respond_with @post
  end

  def destroy
    @post = find_post
    authorize @post
    @post.destroy!

    respond_with @post
  end

  private

  def find_post
    Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :content, :image)
  end

  helper_method def search_string
    params[:q].presence
  end
end
