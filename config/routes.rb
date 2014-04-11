MachineshopPortal::Application.routes.draw do

  resources :styles
  resources :faqs
  resources :white_papers
  resources :example_applications

  get "welcomes/index"
  root(:to => 'welcomes#index')

  resource :dashboard do
    collection do
      get 'index'
      get 'api_usage'
      get 'get_device_instance_last_report'
      get 'get_device_instances'
      get 'get_device_instances_summary'
      get 'get_device_instance_report_count'
      get 'save_widgets_state'
      get 'system_usage'
      get 'retrieve_users'
      get 'retrieve_user_by_id'
      get 'retrieve_rules'
      get 'retrieve_rule_by_id'
      get 'retrieve_custom_apis'
    end
  end

  resource :widget do
    collection do
      get 'get_device_instance_last_report'
      get 'get_device_instances'
      get 'get_device_instances_summary'
      get 'get_device_instance_report_count'
      get 'retrieve_users'
      get 'retrieve_user_by_id'
      get 'retrieve_customers'
      get 'retrieve_customer_by_id'
      get 'retrieve_rules'
      get 'retrieve_rule_by_id'
      get 'retrieve_custom_apis'
      get 'retrieve_custom_api_by_id'
    end
  end

  get "admin/show"

  get "documents/index"

  get "documents/provider_docs", controller: 'documents', action: 'provider_docs', as: 'provider_docs'

  get "documents/show"

  get "reports/index"

  get "reports/show"

  get "resources/api_documentation"

  get "resources/ideas_examples"

  get "users/new_api_key/:id", controller: 'users', action: 'new_api_key', as: 'new_api_key'

  resource :user_session, only: [:new, :create, :destroy]
  resource :rules
  resources :custom_apis, :documents, :users, :customers, :resources, :support_tickets
end
