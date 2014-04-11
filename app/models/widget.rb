class Widget < ActiveRecord::Base
  attr_accessible :name, :default_column

  has_many :user_widgets
  has_many :widget_permissions
end
