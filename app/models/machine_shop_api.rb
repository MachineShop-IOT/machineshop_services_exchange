class MachineShopApi
  include ApplicationHelper

  #Settings listed in config/app_settings.yml
  PLATFORM_DOMAIN = AppSetting.platform_domain
  PLATFORM_ROOT = AppSetting.platform_root
  API_URL = "#{PLATFORM_DOMAIN}#{PLATFORM_ROOT}"

  class << self
    def authenticate(email, password)
      platform_request('/platform/user/authenticate', { email: email, password: password }, :post, nil)
    end

    def get_devices(user)
      platform_request('/platform/device/', nil, :get, user.authentication_token)
    end

    def get_device_instances(user, page=1, per_page=10)
      platform_request("/platform/device_instance?page=#{page}&per_page=#{per_page}", nil, :get, user.authentication_token)
    end

    def get_device_instance_report_count(user, device_instance)
      platform_request('/platform/device_instance/' + device_instance._id + '/report_count', nil, :get, user.authentication_token)
    end

    def get_report_count_per_day(user, start_date, end_date)
      platform_request("/platform/data/total_reports_per_day/#{start_date}/#{end_date}", nil, :get, user.authentication_token)
    end

    def get_reports_per_device_instance_per_day(user, start_date, end_date)
      platform_request("/platform/data/reports_per_device_instance_per_day/#{start_date}/#{end_date}", nil, :get, user.authentication_token)
    end

    def get_device_instance_reports(user, device_instance)
      platform_request('/platform/data/monitor?device_instance_id=' + device_instance._id, nil, :get, user.authentication_token)
    end

    def get_device_instance_last_report(user, device_instance)
      platform_request('/platform/data/monitor?per_page=1&device_instance_id=' + device_instance._id, nil, :get, user.authentication_token)
    end

    def get_device_instances_last_report(user, device_instance_id_array)
      platform_request('/platform/data/monitor/last_reports', {device_instance_ids: device_instance_id_array}, :post, user.authentication_token)
    end

    def get_users(user, query=nil, page=1, per_page=10)
      endpoint = "/platform/user?per_page=#{per_page}&page=#{page}"
      endpoint = "#{endpoint}&query=#{URI.escape(query)}" if query
      platform_request(endpoint, nil, :get, user.authentication_token)
    end

    def get_user(user, user_id)
      platform_request("/platform/user/#{user_id}", nil, :get, user.authentication_token)
    end

    def create_user(current_user, create_hash)
      platform_request('/platform/user/', create_hash, :post, current_user.authentication_token)
    end

    def delete_user(current_user, user_id)
      platform_request("/platform/user/#{user_id}", nil, :delete, current_user.authentication_token)
    end

    def update_user(current_user, update_hash, user_id)
      platform_request("/platform/user/#{user_id}", update_hash, :put, current_user.authentication_token)
    end

    def get_new_api_key(current_user, user_id)
      platform_request("/platform/user/#{user_id}/new_api_key", nil, :get, current_user.authentication_token)
    end

    def create_user_logo(current_user, create_hash, user_id)
      multipart_platform_request("/platform/user/#{user_id}/logo", create_hash, :post, current_user.authentication_token)
      #platform_request("/platform/user/#{user_id}/logo", create_hash, :post, current_user.authentication_token)
    end

    def delete_user_logo(current_user, user_id)
      platform_request("/platform/user/#{user_id}/logo", nil, :delete, current_user.authentication_token)
    end

    def get_customers(user, query=nil, page=1, per_page=10)
      endpoint = "/platform/customer?per_page=#{per_page}&page=#{page}"
      endpoint = "#{endpoint}&query=#{URI.escape(query)}" if query
      platform_request(endpoint, nil, :get, user.authentication_token)
    end

    def get_customer(user, user_id)
      platform_request("/platform/user/#{user_id}", nil, :get, user.authentication_token)
    end

    def create_customer(current_user, create_hash)
      platform_request('/platform/customer', create_hash, :post, current_user.authentication_token)
    end

    def update_customer(current_user, update_hash, customer_id)
      platform_request("/platform/customer/#{customer_id}", update_hash, :put, current_user.authentication_token)
    end

    def delete_customer(current_user, customer_id)
      platform_request("/platform/customer/#{customer_id}", nil, :delete, current_user.authentication_token)
    end

    def get_api_docs(user, search_string)
      platform_request('/platform/api_docs', { search_string: search_string }, :get, user.authentication_token)
    end

    def create_api_doc(user, create_hash)
      platform_request('/platform/api_docs/new', create_hash, :post, user.authentication_token)
    end

    def update_api_doc(user, update_hash, api_doc_id)
      platform_request("/platform/api_docs/#{api_doc_id}", update_hash, :put, user.authentication_token)
    end

    def get_routes(user)
      platform = platform_request('/platform/routes', nil, :get, user.authentication_token)
      begin
        dct = platform_request('/secm/routes', nil, :get, user.authentication_token)
      rescue
      end
      dct ? { :routes=>platform[:routes].concat(dct[:routes]) } : platform
    end

    def get_rules(user, query=nil, page=1, per_page=10)
      endpoint = "/platform/rule?per_page=#{per_page}&page=#{page}"
      endpoint = "#{endpoint}&query=#{URI.escape(query)}" if query
      platform_request(endpoint, nil, :get, user.authentication_token)
    end

    def get_rule(user, id)
      platform_request("/platform/rule/#{id}", id, :get, user.authentication_token)
    end

    def get_join_rule_conditions(user)
      platform_request('/platform/rule/join_rule_conditions', nil, :get, user.authentication_token)
    end

    def get_comparison_rule_conditions(user)
      platform_request('/platform/rule/comparison_rule_conditions', nil, :get, user.authentication_token)
    end

    def create_rule(user, rule_json)
      url = "#{API_URL}/platform/rule"
      response = RestClient.post url, rule_json, headers(user.authentication_token)
      JSON.parse(response, :symbolize_names => true)
    end

    def delete_rule(user, id)
      platform_request("/platform/rule/#{id}", nil, :delete, user.authentication_token)
    end

    def get_rule_last_run_summary(user)
      platform_request("/platform/data/rule_last_run_summary", nil, :get, user.authentication_token)
    end

    def create_custom_api(current_user, create_hash)
      platform_request('/platform/custom/new', create_hash, :post, current_user.authentication_token)
    end

    def get_custom_apis(user, query=nil, page=1, per_page=10)
      endpoint = "/platform/custom?per_page=#{per_page}&page=#{page}"
      endpoint = "#{endpoint}&query=#{URI.escape(query)}" if query
      platform_request(endpoint, nil, :get, user.authentication_token)
    end

    def get_custom_api(user, api_name)
      platform_request("/platform/custom/#{api_name}", nil, :get, user.authentication_token)
    end

    def update_custom_api(user, update_hash, custom_api_name)
      platform_request("/platform/custom/#{custom_api_name}", update_hash, :put, user.authentication_token)
    end

    def delete_custom_api(user, api_name)
      platform_request("/platform/custom/#{api_name}", api_name, :delete, user.authentication_token)
    end

    def get_api_requests_per_day(user, start_date, end_date)
      platform_request("/platform/data/api_requests_per_day/#{start_date}/#{end_date}", nil, :get, user.authentication_token)
    end

    private
    def platform_request(endpoint, body_hash, http_verb, authentication_token)
      url = "#{API_URL}#{endpoint}"
      body = (http_verb == :get ? body_hash : body_hash.to_json)
      begin
        if http_verb == :get || http_verb == :delete
          json_response = RestClient.public_send(http_verb, url, headers(authentication_token, false).merge({ params: body }))
        else
          json_response = RestClient.public_send(http_verb, url, body, headers(authentication_token, false))
        end
      rescue RestClient::Exception => e
        json_response = e.http_body
      end
      return JSON.parse(json_response, :symbolize_names => true)

    end

    def headers(authentication_token, multipart = false)
      heads = { accept: :json}
      heads.merge!({ authorization: "Basic " + Base64.encode64(authentication_token + ':X') }) if authentication_token
      heads.merge!({ content_type: :json }) if !multipart
      heads
    end

    def multipart_platform_request(endpoint, body_hash, http_verb, authentication_token)
      url = "#{API_URL}#{endpoint}"
      payload = {:multipart => true}
      request = RestClient::Request.new(
                                        :method => http_verb,
                                        :url => url,
                                        :headers => headers(authentication_token, true),
                                        :payload => payload.merge!(body_hash)
      )

      resp = request.execute    { |response, request, result, &block|
        if response.code == 200
          response
        else
          puts response
        end
      }
    end
  end
end
