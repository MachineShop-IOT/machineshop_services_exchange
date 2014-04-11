class User
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::AttributeMethods

  attr_accessor :message, :_id, :authentication_token, :authorized_routes, :oauth_providers, :company_name, :csrf_tokens, :current_sign_in_at, :current_sign_in_ip, :email, :first_name, :key, :last_name, :last_sign_in_at, :last_sign_in_ip, :notification_method, :phone_number, :role, :sign_in_count, :tag_ids, :logo_url, :reset_password_sent_at, :reset_password_token, :logo_content_type, :logo_file_name, :logo_file_size, :logo_fingerprint, :logo_updated_at, :logo_upload, :remember_created_at, :publisher_id, :error, :keychain, :backtrace, :password
  attr_reader :attributes

  def initialize(attributes={})
    @attributes = attributes
    @attributes.each do |k, v|
      self.send("#{k}=", v) if self.respond_to?("#{k}=")
    end
  end

  def persisted?
    _id.present?
  end

  def widgets
    @user_widgets = UserWidget.where(user_id: _id)

    #####   Make default widgets for users w/o widgets   #####

    if @user_widgets.length == 0
      col1_position = -1
      col2_position = -1

      allowed_widgets.each do |widget_perm|
        if widget = widget_perm.widget
          user_widget = UserWidget.new({widget_id: widget.id, user_id: _id, column: widget.default_column})
          @user_widgets << user_widget
        end
      end

      @user_widgets.each do |widget|
        if widget.column == 1
          widget[:position] = col1_position += 1
          widget.save

        elsif widget.column == 2
          widget[:position] = col2_position += 1
          widget.save
        end
      end
    end
    return @user_widgets
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def id
    _id
  end

  def publisher?
    role == "publisher"
  end

  def admin?
    role == "admin"
  end

  def consumer?
    role == "consumer"
  end

  def allowed_widgets
    WidgetPermission.where(role: role)
  end

  def route_options
    routes = MachineShopApi.get_routes(self)
    routes[:routes]
  end

  def device_instances(page=1,per_page=10)
    di_params = MachineShopApi.get_device_instances(self, page, per_page)
    ret_array = []
    di_params.each do |di|
      ret_array << DeviceInstance.new(di)
    end
    return ret_array
  end

  def users(page=1, query=nil, per_page=10)
    ret_array = []
    if role == 'admin'
      user_array = MachineShopApi.get_users(self, query, page, per_page)
      user_array.each do |user_params|
        ret_array << User.new(user_params)
      end
    end
    return ret_array
  end

  def user(user_id)
    if role == 'admin'
      return User.new(MachineShopApi.get_user(self, user_id))
    end
  end

  def customers(page=1, query=nil, per_page=10)
    ret_array = []
    if role == 'publisher'
      customer_array = MachineShopApi.get_customers(self, query, page, per_page)
      customer_array.each do |customer_params|
        ret_array << User.new(customer_params)
      end
    end
    return ret_array
  end

  def customer(user_id)
    if role == 'admin'
      return User.new(MachineShopApi.get_user(self, user_id))
    else role == 'publisher'
      return Customer.new(MachineShopApi.get_customer(self, user_id))
    end
  end

  def rules(page=1, query=nil, per_page=10)
    ret_array = []
    rule_array = MachineShopApi.get_rules(self, query, page, per_page)
    rule_array.each do |rule_params|
      ret_array << Rule.new(rule_params)
    end
    return ret_array
  end

  ########## should user_id be rule_id??
  def rule(rule_id)
    Rule.new(MachineShopApi.get_rule(self, user_id))
  end

  def custom_apis(page=1, query=nil, per_page=10)
    ret_array = []
    custom_api_array = MachineShopApi.get_custom_apis(self, query, page, per_page)
    custom_api_array.each do |custom_api_params|
      ret_array << CustomApi.new(custom_api_params)
    end
    return ret_array
  end

  def custom_api(api_name)
    CustomApi.new(MachineShopApi.get_custom_api(self, api_name))
  end

  def documents(documents)
    documented_routes = []
    documents.each do |document|
      documented_routes << document[:end_point]
    end
    avail_routes = self.route_options
    undocumented = avail_routes.sort - documented_routes.sort
    unless undocumented == []
      id = 0
      ret_array = []
      need_docs = avail_routes - documented_routes
      need_docs.each do |end_point|
        ret_array << { _id: "#{id += 1}_no_doc", category: "Uncategorized", end_point: end_point, description: "No Description", parameters: nil, return_example: "{ No Example }", example_code: "{ No Example }"}
      end
      ret_array
    end
  end

  def update(update_hash, current_user)
    @attributes.merge!(update_hash)
    User.new(MachineShopApi.update_user(current_user, update_hash, id))
  end

  def self.create(create_hash, current_user)
    if current_user.role == 'admin'
      User.new(MachineShopApi.create_user(current_user, create_hash))
    end
  end

  def destroy(current_user)
    MachineShopApi.delete_user(current_user, id)
  end

  def zen_id
    user_response = SupportTicket.call_zendesk("/users/search.json?external_id=#{self._id}")
    user_array = JSON.parse(user_response.body, :symbolize_names => true)[:users]
    user_array.length > 0 ? user_array[0][:id] : nil
  end

  def upload_logo(current_user, tmpfile)
    MachineShopApi.create_user_logo(current_user, {logo: tmpfile}, id)
  end

  def sort_my_routes
    base_hash = {}
    routes = self.authorized_routes != nil ? self.authorized_routes.uniq.compact : self.route_options.uniq.compact
    routes.each do |route|
      # build keys of the hash based on the resource (disregarding http verb), and set value to []
      # exp: "GET/users" yields { "users" => [] }
      resource = route.split('/')[1]
      if !base_hash.has_key?(resource) && !resource.blank?
        base_hash[resource] = []
      end
      # throw the route into the value array associated with the appropriate key
      base_hash[resource] << route
    end
    return Hash[base_hash.sort]
  end
end
