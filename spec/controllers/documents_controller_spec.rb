require 'spec_helper'

describe DocumentsController do
  context 'get :index' do
    let(:user) { double }
    let(:documents) { double }
    let(:document_categories) { double }

    before do
      controller.stub(:current_user) { user }
      Document.stub(:load_by_category).with(documents) { document_categories }
    end

    it 'returns the api_docs from the platform' do
      MachineShopApi.stub(:get_api_docs).with(user, nil) { documents }
      get :index
      expect(assigns[:document_categories]).to eq document_categories
    end

    it 'gets docs with a search string if provided' do
        MachineShopApi.stub(:get_api_docs).with(user, 'search string') { documents }
        get :index, search_string: 'search string'
        expect(assigns[:document_categories]).to eq document_categories

    end
  end
end
