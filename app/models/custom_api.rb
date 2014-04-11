class CustomApi
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::AttributeMethods

  attr_accessor :body, :_id, :user_id, :name, :base_domain, :protocol, :endpoint, :action, :soap_wsdl_namespace, :soap_action, :soap_operation, :soap_operation_namespace, :method, :service_type, :headers, :authenticity_token, :created_at, :updated_at, :deleted_at, :encrypted_base_domain, :encrypted_endpoint, :encrypted_headers, :error, :message
  attr_reader :attributes

  def initialize(attributes={})
    @attributes = attributes
    @attributes.each do |k, v|
      self.send("#{k}=", v)
    end
  end

  def persisted?
    _id.present?
  end

  def id
    _id
  end

  def self.create(current_user, create_hash)
    custom_api = CustomApi.new(MachineShopApi.create_custom_api(current_user, create_hash))
  end
end
