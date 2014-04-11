class UsersController < ApplicationController
  include ApplicationHelper

  before_filter :require_signed_in_user

  def index
  end

  def show
    @user = find_user(params[:id], page=1, query=nil, expire_cache=params[:updated])
  end

  def new
    @method = :post
    @user = User.new
  end

  def create
    params[:user][:authorized_routes].reject!(&:empty?) if params[:user][:authorized_routes]
    @user = User.create(params[:user], current_user)
    if @user.error
      render :new
    else
      handle_logo(@user)
      redirect_to :action => 'show', :id => @user.id
    end
  end

  def edit
    page = params[:page] if params[:page]
    query = params[:query] if params[:query]
    @user = find_user(params[:id], page=1, query=nil)
    @method = :put
  end

  def update
    @user = find_user(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user][:authorized_routes].reject!(&:empty?) if params[:user][:authorized_routes]
    update = @user.update(params[:user], current_user)
    if update.error
      @user.error = update.error
      render :edit
    else
      handle_logo(update)
      session[:current_user_attributes] = @user.attributes if current_user.id == @user.id
      redirect_to :action => 'show', :id => @user.id, :updated => true
    end
  end

  def destroy
    @user = find_user(params[:id])
    @user.destroy(current_user)
    render nothing: true
  end

  def new_api_key
    id = params[:id]
    if current_user.id == id
      user = MachineShopApi.get_new_api_key(current_user, id)
      if user[:authentication_token]
        session[:current_user_attributes] = nil
        redirect_to new_user_session_path
      else
        redirect_to edit_user_path(current_user), notice: user[:error]
      end
    else
      user = MachineShopApi.get_new_api_key(current_user, id)
      if user[:authentication_token]
        response = { api_key: user[:authentication_token] }
      else
        response = { error: user[:error] }
      end
      respond_to do |format|
        format.json { render json: response }
      end
    end
  end
end
