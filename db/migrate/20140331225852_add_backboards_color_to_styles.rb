class AddBackboardsColorToStyles < ActiveRecord::Migration
  def change
    add_column :styles, :backboards_color, :string
  end
end
