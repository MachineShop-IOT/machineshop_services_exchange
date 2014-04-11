class DashboardsController < ApplicationController
  include ApplicationHelper

  before_filter :require_signed_in_user

  def index
    widgets = current_user.widgets
    @col1 = widgets.where(:column => 1).sort_by &:position
    @col2 = widgets.where(:column => 2).sort_by &:position
  end

  def save_widgets_state
    params[:items].each do |item_num, widget_vals|
      widget = UserWidget.where("widget_id = ? AND user_id = ?", Widget.where(:id => widget_vals[:widget_id]).first, params[:user]).first
      # the next line likely does nothing, and setting it to a variable to use could fix 'rememberable'. See John's old code.
      widget_vals.delete('widget_id')
      widget.update_attributes(widget_vals)
      widget.save!
    end
    render :nothing => true
  end

  def get_device_instance_last_report
    page = params[:page] ? params[:page] : 1
    device = find_device_instance(params[:device_id], page)
    last_report = device.last_report(current_user)
    time = last_report ? format_time(last_report.created_at) : "(no reports)"
    render :partial => 'shared/widgets/last_report', :locals => {time: time, di: device, report: last_report}#</td><td>#{device.name}</td><td>#{device.model}</td><td><div class='btn btn-mini btn-custom-msg'><a href=#>Message Detail</a></div></td>")
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

  def retrieve_rules
    page = params[:page] ? params[:page] : 1
    query = params[:query] ? params[:query] : nil
    rules_array = rules(query, page)
    respond_to do |format|
      format.html { render :partial => 'shared/widgets/rule_list', :locals => {rules: rule_array} }
      format.json { render json: rule_array }
    end
  end
end
