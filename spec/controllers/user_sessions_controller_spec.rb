require 'spec_helper'

describe UserSessionsController do
  describe 'get /new' do
    it 'returns a new user_session' do
      user_session = double
      UserSession.stub(:new) { user_session }
      get :new
      expect(assigns[:user_session]).to eq user_session
    end
  end

  describe 'post' do
    let(:method_call) { post :create, { user_session: { email: 'test@example.com', password: 'testpass' } } }

    before do
      UserSession.stub(:new).with('email' => 'test@example.com', 'password' => 'testpass') { user_session }
      method_call
    end


    context 'with valid params' do
      let(:user) { double(marshal_dump: { authentication_token: 'abc123' }) }
      let(:user_session) { double(authenticate!: user) }

      it 'adds the current_user_attributes to the session' do
        expect(session[:current_user_attributes][:authentication_token]).to eq 'abc123'
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_url)
      end
    end

    context 'with invalid params' do
      let(:user_session) { double(authenticate!: nil) }

      it 'does not add a current_user to the session' do
        expect(session[:current_user_attributes]).to be_nil
      end

      it 'renders the new page' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'delete' do
    before do
      session[:current_user_attributes] = { authentication_token: 'abc123' }
      delete :destroy
    end

    it 'sets the session authentication_token to nil' do
      expect(session[:current_user_attributes]).to be_nil
    end

    it 'redirects to the new page' do
      expect(response).to redirect_to(new_user_session_url)
    end
  end
end
