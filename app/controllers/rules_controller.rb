class RulesController < ApplicationController
  before_filter :require_signed_in_user

  def index
  end

  def show
    @rule = MachineShopApi.get_rule(current_user, params[:id])
  end

  def new
    #call GET/device_instance endpoint
    @device_instances = MachineShopApi.get_device_instances(current_user)
    device_ids = []
    @device_device_instances = {}

    @device_instances.each do |di|
      device_ids << di[:device_id]
      if @device_device_instances[di[:device_id]]
        @device_device_instances[di[:device_id]]
        @device_device_instances[di[:device_id]] << di[:_id]
      else
        @device_device_instances[di[:device_id]] = [di[:_id]]
      end
    end
    device_ids = device_ids.uniq if device_ids.length > 0
    @device_device_instances = @device_device_instances.to_json
    @devices = MachineShopApi.get_devices(current_user)

    # Call endpoint to retrieve all possible rule conditions
    @join_rule_conditions = MachineShopApi.get_join_rule_conditions(current_user).to_json
    @comparison_rule_conditions = MachineShopApi.get_comparison_rule_conditions(current_user).to_json

    respond_to do |format|
      format.html
      format.json { render json: @rule }
    end
  end

  def create
    @rule = MachineShopApi.create_rule(current_user, params[:rule_json])
    if @rule
      redirect_to dashboard_path
    else
      render action: 'new'
    end
  end

  def destroy
    MachineShopApi.delete_rule(current_user, params[:id])
    render :nothing => true
  end
end
