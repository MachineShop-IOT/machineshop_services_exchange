class WidgetsController < ApplicationController
  include ApplicationHelper

  before_filter :require_signed_in_user

  def get_device_instance_last_report
    page = params[:page] ? params[:page] : 1
    device = find_device_instance(params[:device_id], page)
    last_report = DeviceInstance.last_reports(current_user,[params[:device_id]])#device.last_report(current_user)
    last_report = last_report[params[:device_id]]
    time = last_report ? format_time(last_report.created_at) : "(no reports)"
    render :partial => 'shared/widgets/last_report', :locals => {time: time, di: device, report: last_report}
  end

  def get_device_instances_last_reports
    page = params[:page] ? params[:page] : 1
    last_reports = params[:device_instance_ids] ? DeviceInstance.last_reports(current_user,params[:device_instance_ids]) : nil
    params[:device_instance_ids].each do |id|
      last_reports[id] ? last_reports[id].created_at = format_time(last_reports[id].created_at) : last_reports[id] = nil
    end
    render :partial => 'shared/widgets/last_reports', :locals => {last_reports: last_reports, page: page}
  end

  def get_device_instances
    page = params[:page] ? params[:page] : 1
    render :partial => 'shared/widgets/device_instances_last_report', :locals => {device_instances: device_instances(page)}
  end

  def get_device_instances_summary
    page = params[:page] ? params[:page] : 1
    render :partial => 'shared/widgets/device_instances_report_count', :locals => {device_instances: device_instances(page)}
  end

  def get_device_instance_report_count
    page = params[:page] ? params[:page] : 1
    device = find_device_instance(params[:device_id], page)
    count_object = [device._id, device.name, device.total_reports(current_user)[:count]]
    render :partial => 'shared/widgets/report_count', :locals => {device_instance_count: count_object, device_instance: device}
  end

  def api_usage
    render json: [400, 300, 200, 500, 600, 500, 100, 300, 800, 900, 300, 500, 700]
  end

  def system_usage
    render json: [700, 800, 200, 500, 600, 100, 800, 700, 200, 100, 600, 700, 700]
  end

  def retrieve_users
    page = params[:page] ? params[:page] : 1
    query = params[:query] ? params[:query] : nil
    users_array = users(query, page)
    respond_to do |format|
      format.html { render :partial => 'shared/widgets/user_list', :locals => {users: users_array} }
      format.json { render json: users_array }
    end
  end

  def retrieve_user_by_id
    user = find_user(params[:user_id], params[:page], params[:query])
    render :partial => 'shared/widgets/user_row', :locals => {user_instance: user}
  end

  def retrieve_customers
    page = params[:page] ? params[:page] : 1
    query = params[:query] ? params[:query] : nil
    customers_array = customers(query, page)
    respond_to do |format|
      format.html { render :partial => 'shared/widgets/customer_list', :locals => {customers: customers_array} }
      format.json { render json: customers_array }
    end
  end

  def retrieve_customer_by_id
    customer = find_customer(params[:user_id], params[:page], params[:query])
    render :partial => 'shared/widgets/customer_row', :locals => {customer_instance: customer}
  end

  def retrieve_rules
    page = params[:page] ? params[:page] : 1
    query = params[:query] ? params[:query] : nil
    rules_array = rules(query, page)
    respond_to do |format|
      format.html { render :partial => 'shared/widgets/rule_list', :locals => {rules: rules_array} }
      format.json { render json: rules_array }
    end
  end

  def retrieve_rule_by_id
    rule = find_rule(params[:rule_id], params[:page], params[:query])
    render :partial => 'shared/widgets/rule_row', :locals => {rule_instance: rule}
  end

  def retrieve_custom_apis
    page = params[:page] ? params[:page] : 1
    query = params[:query] ? params[:query] : nil
    custom_apis_array = custom_apis(query, page)
    respond_to do |format|
      format.html { render :partial => 'shared/widgets/custom_api_list', :locals => {custom_apis: custom_apis_array} }
      format.json { render json: custom_apis_array }
    end
  end

  def retrieve_custom_api_by_id
    custom_api = find_custom_api(params[:custom_api_id], params[:page], params[:query])
    render :partial => 'shared/widgets/custom_api_row', :locals => {custom_api_instance: custom_api}
  end
end
