class DeviceInstance < OpenStruct
  def reports(user)
    # call the api for a specific device_instance to retrieve reports
  end

  # def total_reports(user)
  #   total_reports = MachineShopApi.get_device_instance_report_count(user, self)
  #   # total_reports = MachineShopApi.get_device_instance_reports(user, self).count
  #   if total_reports
  #     return total_reports
  #   else
  #     return 0
  #   end
  # end

  def reports_today(user)
    ### reports_today = MachineShopApi.get_device_instance_reports(user, self)
    ### end
    ### if reports_today
    ###   return reports_today
    ### else
    ###   0
    ### end
  end

  def self.last_reports(user, device_instance_id_array)
    report_return = MachineShopApi.get_device_instances_last_report(user, device_instance_id_array)
    return_array = {}
    device_instance_id_array.each do |diid|
      if report_return[diid.to_sym]
        return_array[diid] = report_return[diid.to_sym].is_a?(String) ? nil : Report.new(report_return[diid.to_sym])
      end
    end
    puts "LAST REPORTS: #{return_array}"
    return return_array
  end

  def last_report_for(user)
    report_params = MachineShopApi.get_device_instance_last_report(user, self)[0]
    if report_params
      return Report.new(report_params)
    else
      return nil
    end
  end
end
