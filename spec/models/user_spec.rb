require 'spec_helper'

describe User do
  context 'initialization' do
    it 'saves attributes in an instance' do
      user = User.new(authentication_token: 'abc123')
      expect(user.authentication_token).to eq 'abc123'
    end
  end

  it 'returns a full name' do
    user = User.new(first_name: 'Mister', last_name: 'Tester')
    expect(user.full_name).to eq 'Mister Tester'
  end
end
