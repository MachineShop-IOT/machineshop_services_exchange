require 'spec_helper'

describe ApplicationController do
  it 'returns a current_user' do
    session[:current_user_attributes] = { something: 'else' }
    expect(controller.send(:current_user).something).to eq 'else'
  end
end
