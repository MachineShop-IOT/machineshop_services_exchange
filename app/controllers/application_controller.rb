class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to(:html, :json, :js)
  helper_method :current_user

  protected
  def require_signed_in_user
    redirect_to new_user_session_url, alert: 'Please sign in' unless current_user
  end

  def current_user
    User.new(session[:current_user_attributes]) if session[:current_user_attributes]
  end

  private
  def client
    ZenClient.instance
  end

end

class ZenClient < ZendeskAPI::Client
  def self.instance
    @instance ||= new do |config|
      config.url = "https://machineshop.zendesk.com/api/v2/"
      config.retry = true
      config.username = AppSetting.zen_user + "/token"
      config.token = AppSetting.zen_token
      config.logger = Rails.logger
    end
  end

  def tickets(email)
    search(:query => "requester:#{email}")
  end
end
