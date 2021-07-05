class PostsController < ApplicationController
  def index
    @posts = if search_string
      Post.search_for(search_string, page: params[:page], per_page: 25)
    else
      Post.order(updated_at: :desc).page(params[:page]).per(25)
    end
    authorize @posts

    respond_to do |format|
      format.html
      format.js { render 'kaminari/infinite-scrolling', locals: { objects: @posts } }
    end
  end

  def show
    @post = find_post
    authorize @post
  end

  def new
    @post = Post.new
    authorize @post
  end

  def edit
    @post = find_post
    authorize @post
  end

  def create
    @post = Post.new(post_params)
    authorize @post

    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def update
    @post = find_post
    authorize @post

    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post = find_post
    authorize @post
    @post.destroy!
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  def find_post
    Post.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :content, :copyright, clips_attributes: [ :id, :image, :_destroy ])
  end

  helper_method def search_string
    params[:q].presence
  end
end
