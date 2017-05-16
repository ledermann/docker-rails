class PostsController < ApplicationController
  respond_to :html, :json

  def index
    @posts = if search_string
      Post.search search_string,
                  fields:       [ 'title^10', 'content' ],
                  match:        :word_start,
                  misspellings: { prefix_length: 2 },
                  highlight:    { tag: '<strong>' },
                  page:         params[:page],
                  per_page:     25
    else
      Post.order(updated_at: :desc).
           page(params[:page]).
           per(25)
    end

    respond_with @posts do |format|
      format.js { render 'kaminari/infinite-scrolling', locals: { objects: @posts } }
    end
  end

  def show
    @post = find_post
    respond_with @post do |format|
      format.pdf { render pdf:          @post.title,
                          disposition:  'inline',
                          show_as_html: params[:debug].present? }
    end
  end

  def new
    @post = Post.new
  end

  def edit
    @post = find_post
    respond_with @post
  end

  def create
    @post = Post.create(post_params)
    respond_with @post
  end

  def update
    @post = find_post
    @post.update(post_params)
    respond_with @post
  end

  def destroy
    @post = find_post
    @post.destroy!
    respond_with @post
  end

  private
    def find_post
      Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content)
    end

    helper_method def search_string
      params[:q].presence
    end
end
