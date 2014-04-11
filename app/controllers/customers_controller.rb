class CustomersController < ApplicationController
  include ApplicationHelper

  before_filter :require_signed_in_user

  def index

  end

  def show
    @customer = find_customer(params[:id], page=1, query=nil, expire_cache=params[:updated])
  end

  def new
    @method = :post
    @customer = Customer.new
  end

  def create
    domain_hash = {:domain => nil} if !current_user.attributes[:domain]  
    sub_role_hash = {:sub_role => ""} if !current_user.attributes[:sub_role]
    
    if sub_role_hash || domain_hash
      update_hash = (sub_role_hash && domain_hash) ? sub_role_hash.merge!(domain_hash) : sub_role_hash || domain_hash
      User.new(MachineShopApi.update_user(current_user, update_hash, current_user.id))
    end

    params[:customer][:authorized_routes].reject!(&:empty?) if params[:customer][:authorized_routes]
    
    @customer = Customer.create(current_user, params[:customer])

    if @customer.error
      redirect_to new_customer_path, notice: @customer.error
    else
      customer_handle_logo(@customer)
      redirect_to customer_path(@customer.id)
    end
  end

  def edit
    @customer = find_customer(params[:id])
    @method = :put
  end

  def update
    @customer = find_customer(params[:id])
    params[:customer].merge!(params[:user]) if params[:user]
    params[:customer].delete(:password) if params[:customer][:password].blank?
    params[:customer][:authorized_routes].reject!(&:empty?) if params[:customer][:authorized_routes]
    update = Customer.new(MachineShopApi.update_customer(current_user, params[:customer], params[:id]))
    if update.error
      @customer.error = update.error
      redirect_to edit_customer_path, notice: @customer.error
    else
      customer_handle_logo(update)
      # handle_logo(@customer)
      redirect_to customer_path(@customer.id), updated: true
    end
  end

  def destroy
    @customer = MachineShopApi.delete_customer(current_user, params[:id])
    render nothing: true
  end
end
