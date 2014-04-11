class WidgetPermission < ActiveRecord::Base
  attr_accessible :role, :widget_id

  belongs_to :widget
end
