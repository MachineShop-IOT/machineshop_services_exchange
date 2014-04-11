class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if user = @user_session.authenticate!
      session[:current_user_attributes] = user.attributes
      redirect_to root_url
    else
      render :new
    end
  end

  def destroy
    session[:current_user_attributes] = nil
    redirect_to new_user_session_url
  end
end
