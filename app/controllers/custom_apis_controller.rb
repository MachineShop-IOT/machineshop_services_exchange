class CustomApisController < ApplicationController
  include ApplicationHelper

  before_filter :require_signed_in_user

  def index
  end

  def show
    @custom_api = current_user.custom_api(params[:id])
  end

  def new
    @method = :post
    @custom_api = CustomApi.new
    @document = Document.new
  end

  def create
    params[:custom_api][:name] = params[:custom_api][:name].gsub(' ', '_')
    @custom_api = CustomApi.create(current_user, params[:custom_api])
    if @custom_api.error
      render action: 'new'
    else
      redirect_to action: 'show', id: @custom_api.name
    end
  end

  def edit
    @custom_api = current_user.custom_api(params[:id])
    @name = @custom_api.name
    @method = :put
  end

  def update
    params[:custom_api][:name] = params[:custom_api][:name].gsub(' ', '_')
    @custom_api = CustomApi.new(MachineShopApi.update_custom_api(current_user, params[:custom_api], params[:old_name]))
    if @custom_api.error
      render action: 'edit', id: params[:old_name]
    else
      redirect_to action: 'show', id: @custom_api.name, updated: true
    end
  end

  def destroy
    @custom_api = MachineShopApi.delete_custom_api(current_user, params[:id])
    render nothing: true
  end
end
