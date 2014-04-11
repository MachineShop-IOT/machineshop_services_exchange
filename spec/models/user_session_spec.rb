require 'spec_helper'

describe UserSession do
  let(:user_session) { UserSession.new(email: 'test@example.com', password: 'testpass') }

  context 'with a valid password' do
    before do
      MachineShopApi.stub(:authenticate).with('test@example.com', 'testpass') { { _id: '12345', authentication_token: 'abc123' } }
    end

    it 'builds a user with the appropriate attributes' do
      user = user_session.authenticate!
      expect(user.authentication_token).to eq 'abc123'
    end

    it 'has empty errors' do
      user_session.authenticate!
      expect(user_session.errors).to be_empty
    end
  end

  context 'with an invalid password' do
    before do
      MachineShopApi.stub(:authenticate).with('test@example.com', 'testpass') { { error: 'invalid email' } }
    end

    it 'returns false to authenicate' do
      expect(user_session.authenticate!).to be_false
    end

    it 'has an error' do
      user_session.authenticate!
      expect(user_session.errors).to eq(['invalid email'])
    end
  end
end
