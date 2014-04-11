class CreateWidgetPermissions < ActiveRecord::Migration
  def change
    create_table :widget_permissions do |t|
      t.string :role
      t.integer :widget_id
      t.timestamps
    end
    add_index(:widget_permissions, :widget_id)
  end
end
