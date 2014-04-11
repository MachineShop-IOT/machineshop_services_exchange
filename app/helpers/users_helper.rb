module UsersHelper
  def categorized_routes_hash
    current_user.sort_my_routes
  end
end
