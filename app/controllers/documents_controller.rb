class DocumentsController < ApplicationController
  before_filter :require_signed_in_user

  def index
    if params[:search_string]
      @search_results = "search_results"
    end
    documents = MachineShopApi.get_api_docs(current_user, params[:search_string])
    if current_user.admin?
      undocumented = current_user.documents(documents)
      undocumented.each do |document|
        documents << document
      end
    end
    documents_with_categories = Hash[Document.load_by_category(documents).sort]
    @document_categories = { documents_with_categories.keys[0] => documents_with_categories.values[0] }
    @category_names = documents_with_categories.keys
  end

  def show; end

  def new; end

  def provider_docs
    documents = MachineShopApi.get_api_docs(current_user, params[:search_string])
    if current_user.admin?
      undocumented = current_user.documents(documents)
      undocumented.each do |document|
        documents << document
      end
    end
    provider_docs = documents.select { |hash| hash[:category] == params[:provider] }
    @document_categories = Document.load_by_category(provider_docs)
    @category_names = @document_categories.keys
    render partial: 'provider_docs', locals: { documents: @document_categories, all_categories: @category_names }
  end

  def provider_docs
    documents = MachineShopApi.get_api_docs(current_user, params[:search_string])
    if current_user.admin?
      undocumented = current_user.documents(documents)
      undocumented.each do |document|
        documents << document
      end
    end
    provider_docs = documents.select { |hash| hash[:category] == params[:provider] }
    @document_categories = Document.load_by_category(provider_docs)
    @category_names = @document_categories.keys
    render partial: 'provider_docs', locals: { documents: @document_categories, all_categories: @category_names }
  end

  def create; end

  def edit; end

  def update
    parameters_hash = params[:parameters_keys].zip(params[:parameters_values])
    params[:parameters] = Hash[*parameters_hash.flatten]
    params.delete :parameters_keys
    params.delete :parameters_values
    if /_no_doc/.match(params[:id])
      params.delete :id
      document = Document.new(MachineShopApi.create_api_doc(current_user, params))
      render partial: 'doc_info', locals: {document: document}
    else
      document = Document.new(MachineShopApi.update_api_doc(current_user, params, params[:id]))
      render partial: 'doc_info', locals: {document: document}
    end
  end

  def destroy; end
end
