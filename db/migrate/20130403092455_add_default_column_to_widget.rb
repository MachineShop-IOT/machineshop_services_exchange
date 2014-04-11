class AddDefaultColumnToWidget < ActiveRecord::Migration
  def change
    add_column :widgets, :default_column, :integer
  end
end
