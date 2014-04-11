class WelcomesController < ApplicationController
  include ApplicationHelper

  before_filter :require_signed_in_user

  def index
  end
end
