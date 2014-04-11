class Document < OpenStruct
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::AttributeMethods

  def self.load_by_category(document_hashes)
    category_hash = Hash.new { |hash, key| hash[key] = [] }
    document_hashes.inject(category_hash) do |category_hash, document_hash|
      category_hash[document_hash[:category]] << Document.new(document_hash)
      category_hash
    end
  end

  def self.create(current_user, create_hash)
    api_doc = Document.new(MachineShopApi.create_api_doc(current_user, create_hash))
  end
end
