class StylesController < ApplicationController
  before_filter :require_signed_in_user
  before_filter :ensure_access, :except => ["show"]

  def index
    @styles = Style.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @styles }
    end
  end

  def show
    @style = Style.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @style }
      format.css { render css: @style, :content_type => "text/css"}
    end
  end

  def new
    style = Style.find_by_user_id(current_user._id)
    if style
      redirect_to edit_style_path(style)
    else
      @style = Style.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @style }
      end
    end
  end

  def edit
    # @method = :put
    @style = Style.find(params[:id])
  end

  def create
    @style = Style.new(params[:style])

    respond_to do |format|
      if @style.save
        format.html { redirect_to @style, notice: 'Style was successfully created.' }
        format.json { render json: @style, status: :created, location: @style }
      else
        format.html { render action: "new" }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @style = Style.find(params[:id])

    respond_to do |format|
      if @style.update_attributes(params[:style])
        format.html { redirect_to @style, notice: 'Style was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @style = Style.find(params[:id])
    @style.destroy

    respond_to do |format|
      format.html { redirect_to styles_url }
      format.json { head :no_content }
    end
  end

  protected
  def ensure_access
    redirect_to root_url unless current_user.publisher? || current_user.admin?
  end
end
