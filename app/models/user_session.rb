class UserSession
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :email, :password

  def initialize(args={})
    @email = args[:email]
    @password = args[:password]
    @errors = []
  end

  def authenticate!
    user_params = MachineShopApi.authenticate(@email, @password)
    if user_params[:error].present?
      @errors << user_params[:error]
    else
      @user = User.new(user_params)
    end
    @user
  end

  def errors
    @errors
  end

  def persisted?
    false
  end
end
