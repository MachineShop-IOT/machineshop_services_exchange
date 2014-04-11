class WhitePapersController < ApplicationController
  # GET /white_papers
  # GET /white_papers.json
  def index
    @white_papers = WhitePaper.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @white_papers }
    end
  end

  # GET /white_papers/1
  # GET /white_papers/1.json
  def show
    @white_paper = WhitePaper.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @white_paper }
    end
  end

  # GET /white_papers/new
  # GET /white_papers/new.json
  def new
    if current_user.admin?
      @white_paper = WhitePaper.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @white_paper }
      end
    else
      redirect_to white_papers_url
    end
  end

  # GET /white_papers/1/edit
  def edit
    if current_user.admin?
      @white_paper = WhitePaper.find(params[:id])
    else
      redirect_to white_papers_url
    end
  end

  # POST /white_papers
  # POST /white_papers.json
  def create
    @white_paper = WhitePaper.new(params[:white_paper])

    respond_to do |format|
      if @white_paper.save
        format.html { redirect_to @white_paper, notice: 'White paper was successfully created.' }
        format.json { render json: @white_paper, status: :created, location: @white_paper }
      else
        format.html { render action: "new" }
        format.json { render json: @white_paper.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /white_papers/1
  # PUT /white_papers/1.json
  def update
    @white_paper = WhitePaper.find(params[:id])

    respond_to do |format|
      if @white_paper.update_attributes(params[:white_paper])
        format.html { redirect_to @white_paper, notice: 'White paper was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @white_paper.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /white_papers/1
  # DELETE /white_papers/1.json
  def destroy
    @white_paper = WhitePaper.find(params[:id])
    @white_paper.destroy
    render nothing: true

    # respond_to do |format|
    #   format.html { redirect_to white_papers_url }
    #   format.json { head :no_content }
    # end
  end
end
