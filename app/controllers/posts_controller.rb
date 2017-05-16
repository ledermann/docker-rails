class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
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

    respond_to do |format|
      format.html
      format.json
      format.js { render 'kaminari/infinite-scrolling', locals: { objects: @posts } }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  # GET /posts/1.pdf
  def show
    respond_to do |format|
      format.html
      format.json
      format.pdf { render pdf:          @post.title,
                          disposition:  'inline',
                          show_as_html: params[:debug].present? }
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy!
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content)
    end

    helper_method def search_string
      params[:q].presence
    end
end
