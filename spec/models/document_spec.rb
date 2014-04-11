require 'spec_helper'

describe Document do
  it 'loads by category' do
    document_hashes = [
      { category: 'category1', end_point: 'endpoint1' },
      { category: 'category2', end_point: 'endpoint2' },
      { category: 'category1', end_point: 'endpoint3' },
    ]
    documents_by_category = Document.load_by_category(document_hashes)
    expect(documents_by_category['category1'].map(&:end_point)).to eq ['endpoint1', 'endpoint3']
    expect(documents_by_category['category2'].map(&:end_point)).to eq ['endpoint2']
  end
end
