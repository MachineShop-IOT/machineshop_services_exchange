class UserWidget < ActiveRecord::Base
  attr_accessible :widget_id, :user_id, :column, :position, :collapsed

  belongs_to :widget
end
