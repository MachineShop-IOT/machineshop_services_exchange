class ReportsController < ApplicationController
  def index
    today = Date.today
    end_date = today.strftime("%Y-%m-%d")
    start_date = (today - 30).strftime("%Y-%m-%d")

    reports = MachineShopApi.get_report_count_per_day(current_user, start_date, end_date)
    @massaged_reports = Hash[reports.map { |k, v| k = Date.parse(k.to_s).strftime("%B %e, %Y").to_sym, v } ]

    di_reports = MachineShopApi.get_reports_per_device_instance_per_day(current_user, start_date, end_date)
    @massaged_di_reports = di_reports.each do |hash|
      hash[:data] = Hash[hash[:data].map { |k, v| k = Date.parse(k.to_s).strftime("%B %e, %Y").to_sym, v } ]
    end

    @rule_summary = MachineShopApi.get_rule_last_run_summary(current_user)

    begin
      api_requests = MachineShopApi.get_api_requests_per_day(current_user, start_date, end_date)
      @massaged_api_requests = Hash[api_requests.map { |k, v| k = Date.parse(k.to_s).strftime("%B %e, %Y").to_sym, v } ]
    rescue
      @massaged_api_requests = {}
    end
    
    respond_to do |format|
      format.html
      format.json { render json: @reports}
    end
  end

  def show
  end

end
