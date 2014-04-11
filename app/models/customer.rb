class Customer
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::AttributeMethods

  attr_accessor :_id, :authentication_token, :authorized_routes, :company_name, :current_sign_in_at, :current_sign_in_ip, :email, :first_name, :key, :last_name, :last_sign_in_at, :last_sign_in_ip, :notification_method, :phone_number, :role, :sign_in_count, :tag_ids, :logo_url, :reset_password_sent_at, :reset_password_token, :logo_content_type, :logo_file_name, :logo_file_size, :logo_fingerprint, :logo_updated_at, :remember_created_at, :publisher_id, :error, :keychain, :logo_upload
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

  def id
    _id
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.create(current_user, create_hash)
    customer = Customer.new(MachineShopApi.create_customer(current_user, create_hash))
  end

  def customer_upload_logo(current_user, tmpfile, customer_id)
    MachineShopApi.create_user_logo(current_user, {logo: tmpfile}, customer_id)
  end
end
