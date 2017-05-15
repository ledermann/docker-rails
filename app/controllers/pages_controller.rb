class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  # GET /pages
  # GET /pages.json
  def index
    @pages = if search_string
      Page.search search_string,
                  fields:       [ 'title^10', 'content' ],
                  match:        :word_start,
                  misspellings: { prefix_length: 2 },
                  highlight:    { tag: '<strong>' },
                  page:         params[:page],
                  per_page:     25
    else
      Page.order(updated_at: :desc).
           page(params[:page]).
           per(25)
    end

    respond_to do |format|
      format.js { render 'kaminari/infinite-scrolling', locals: { objects: @pages } }
      format.html
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  # GET /pages/1.pdf
  def show
    respond_to do |format|
      format.html
      format.json
      format.pdf { render pdf:          @page.title,
                          disposition:  'inline',
                          show_as_html: params[:debug].present? }
    end
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy!
    respond_to do |format|
      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title, :content)
    end

    helper_method def search_string
      params[:q].presence
    end
end
