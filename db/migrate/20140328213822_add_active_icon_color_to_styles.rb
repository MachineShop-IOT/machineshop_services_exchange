class AddActiveIconColorToStyles < ActiveRecord::Migration
  def change
    add_column :styles, :active_icon_color, :string
  end
end
