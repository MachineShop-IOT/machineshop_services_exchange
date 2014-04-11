class Style < ActiveRecord::Base
  attr_accessible :name, :link_color, :link_hover_color, :font_color, :background_color, :font_type, :active_icon_color, :backboards_color, :user_id
end
