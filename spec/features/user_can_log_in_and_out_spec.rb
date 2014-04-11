require 'spec_helper'

feature 'user can log in and out' do
  scenario 'user can log in with valid params' do
    pending
    visit '/user_session/new'
  end
  scenario 'user can\'t log in with invalid params'
  scenario 'user can log out'
end
