class SupportTicket < OpenStruct

  def self.list_by_user(user)
    # GET /api/v2/users/{user_id}/tickets/requested.json
    tickets_response = self.call_zendesk("/users/#{user.zen_id}/tickets/requested.json?include=last_audits")
    tickets_array = JSON.parse(tickets_response.body, :symbolize_names => true)[:tickets]
    return_array = []
    tickets_array.each do |ticket| 
      puts ticket.to_json
      return_array << SupportTicket.new(ticket) 
    end if tickets_array
    return return_array
  end

  def self.create(user, subject, message)
    new_ticket = {ticket: { requester: 
                            { name: user.full_name, 
                              email: user.email,
                              external_id: user._id
                            },
                            submitter_id: AppSetting.zen_submitter,
                            subject: subject,
                            comment: 
                            { body: message
                            }
                          }
                        }
    ticket_response = self.call_zendesk('/tickets.json', :post, {:body => new_ticket.to_json})
    ticket_hash = JSON.parse(ticket_response.body, :symbolize_names => true)[:ticket]
    SupportTicket.new(ticket_hash)
  end

  def self.retrieve(id)
    ticket_response = self.call_zendesk("/tickets/#{id}.json")
    history_response = self.call_zendesk("/tickets/#{id}/audits.json")
    ticket_hash = JSON.parse(ticket_response.body, :symbolize_names => true)[:ticket]
    history_hash = JSON.parse(history_response.body, :symbolize_names => true)
    comment_count = history_hash[:count]
    history_array = history_hash[:audits]
    users = self.user_map
    puts history_array.to_json
    history = self.parse_history(history_array, users)
    ticket_hash = ticket_hash.merge({:history => history, users: users, comment_count: comment_count})
    ticket = SupportTicket.new(ticket_hash)
  end

  def self.update(id, comment, user)
    updates = {ticket: {comment: {:public => true, body: comment, author_id: user.zen_id} } }
    self.call_zendesk("/tickets/#{id}.json", :put, {:body => updates.to_json})
  end

  def self.call_zendesk(endpoint, method = :get, options = {})
    headers = {:headers => { 'Content-Type' => 'application/json'}}
    real_options = {:basic_auth => {:username => AppSetting.zen_user, :password => AppSetting.zen_token} }.merge(headers).merge(options)
    HTTParty.send method, "#{AppSetting.zen_url}#{endpoint}", real_options
  end

  def self.parse_history(history_array, user_hash)
    ret_array = []
    if history_array
      history_array.each do |h|
        in_create = false
        creator_id = nil
        comment_hash = nil
        h[:events].each do |e| 
          if e[:type] == "Create" && e[:field_name] == "requester_id"
            in_create = true
            creator_id = Integer(e[:value])
            comment_hash[:author] = user_hash[creator_id] if comment_hash
          end
          if e[:body] && e[:type] == "Comment"
            comment = e[:body]
            if in_create
              author = user_hash[creator_id]
              in_create = false
            else
              author = user_hash[e[:author_id]]
            end
            comment_hash = {comment_id: h[:id], created_at: h[:created_at], comment: comment, author: author }
          end
        end
        ret_array << comment_hash
      end
    end
    return ret_array
  end

  def self.user_map
    user_response = self.call_zendesk("/users.json")
    user_array = JSON.parse(user_response.body, symbolize_names: true)[:users]
    Hash[user_array.map{|u| [u[:id],u[:name]]}]
  end
end
