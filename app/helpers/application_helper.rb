module ApplicationHelper
  def device_instances(page=1)
    DeviceInstance.new
    instances = Rails.cache.fetch("#{current_user._id}device_instances_page#{page}", expires_in: 5.minutes, race_condition_ttl: 10) do
      Marshal.dump(current_user.device_instances(page))
    end
    return Marshal.load(instances)
    # return cache_it(current_user.device_instances, 'device_instances')
  end

  def find_device_instance(id, page=1)
    selected = device_instances(page).select{|k| k._id == id}
    puts device_instances
    return selected ? selected[0] : nil
  end

  def users(query=nil, page=1, per_page=10, expire_cache=false)
    cache_key = "#{current_user._id}users#{query}#{page}"
    Rails.cache.delete_matched(cache_key) if expire_cache
    users = Rails.cache.fetch(cache_key, expires_in: 1.seconds, race_condition_ttl: 10) do
      Marshal.dump(current_user.users(page, query, per_page))
    end
    users ? Marshal.load(users) : []
  end

  def customers(query=nil, page=1, per_page=10, expire_cache=false)
    cache_key = "#{current_user._id}customers#{query}#{page}"
    Rails.cache.delete_matched(cache_key) if expire_cache
    customers = Rails.cache.fetch(cache_key, expires_in: 1.seconds, race_condition_ttl: 10) do
      Marshal.dump(current_user.customers(page, query, per_page))
    end
    customers ? Marshal.load(customers) : []
  end

  def rules(query=nil, page=1, per_page=10)
    rules = Rails.cache.fetch("#{current_user._id}rules#{query}#{page}", expires_in: 1.minute, race_condition_ttl: 10) do
      Marshal.dump(current_user.rules(page, query, per_page))
    end
    rules ? Marshal.load(rules) : []
  end

  def custom_apis(query=nil, page=1, per_page=10)
    custom_apis = Rails.cache.fetch("#{current_user._id}custom_apis#{query}#{page}", expires_in: 1.minute, race_condition_ttl: 10) do
      Marshal.dump(current_user.custom_apis(page, query, per_page))
    end
    custom_apis ? Marshal.load(custom_apis) : []
  end

  def find_user(user_id, page=1, query=nil, expire_cache=false)
    if user_id == current_user.id
      return current_user
    else
      selected = users(query, page, per_page=10, expire_cache).select{|k| k._id == user_id}
      return selected[0] ? selected[0] : current_user.user(user_id)
    end
  end

  def find_customer(user_id, page=1, query=nil, expire_cache=false)
    selected = customers(query, page, per_page=10, expire_cache).select{|k| k._id == user_id}
    return selected[0] ? selected[0] : current_user.customer(user_id)
  end

  def find_rule(rule_id, page=1, query=nil)
    selected = rules(query, page).select{|k| k._id == rule_id}
    return selected[0] ? selected[0] : current_user.rules(rule_id)
  end

  def find_custom_api(custom_api_id, page=1, query=nil)
    selected = custom_apis(query, page).select{|k| k._id == custom_api_id}
    return selected[0] ? selected[0] : current_user.custom_api(custom_api_id)
  end

  def last_report(device_instance)
    report = Rails.cache.fetch(current_user._id + 'last_report', expires_in: 2.minutes, race_condition_ttl: 10) do
      Marshal.dump(device_instance.last_report(current_user))
    end
    return Marshal.load(report)
  end

  def format_time(time_string)
    t = Time.parse(time_string) unless time_string.blank?
    t.strftime("%B %d, %Y %H:%M:%S ")
    #Time.parse(time_string) unless time_string.blank?
  end

  def cache_it(object, cache_key)
    objects = Rails.cache.fetch(current_user._id + cache_key, expires_in: 3.minutes, race_condition_ttl: 10) do
      Marshal.dump(object)
    end
    return Marshal.load(objects)
  end

  def display_json(hash)
    escape_javascript(simple_format(JSON.pretty_generate(hash)))
  end

  def controller?(controllers)
    @active_controller = []
    controllers.each do |controller|
      @active_controller << (params[:controller] == controller).to_s
    end
    return true if @active_controller.include? 'true'
  end

  def status_class
    {
      "new" => "label label-inverse",
      "open" => "label label-info",
      "pending" => "label label-warning",
      "hold" => "label label-warning",
      "solved" => "label label-success",
      "closed" => "label"
    }
  end

  def handle_logo(user)
    if params[:logo_upload]
      data = params[:logo_upload]
      file_data = data.tempfile
      file = File.open(file_data, 'r')
      user.upload_logo(current_user, file)
    else
    end
  end

  def customer_handle_logo(customer)
    if params[:logo_upload]
      data = params[:logo_upload]
      file_data = data.tempfile
      file = File.open(file_data, 'r')
      customer.customer_upload_logo(current_user, file, customer.id)
    else
    end
  end
end
