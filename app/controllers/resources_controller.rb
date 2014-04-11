class ResourcesController < ApplicationController
  before_filter :require_signed_in_user

  def index

  end

  def api_documentation
    documents = MachineShopApi.get_api_docs(current_user, params[:search_string])
    @document_categories = Document.load_by_category(documents)
  end

  def ideas_examples

  end
end
