class CreateUserWidgets < ActiveRecord::Migration
  def change
    create_table :user_widgets do |t|
      t.integer :column
      t.integer :position
      t.boolean :collapsed, :default => false
      t.string :user_id
      t.integer :widget_id
      t.timestamps
    end
    add_index(:user_widgets, :widget_id)
  end
end
