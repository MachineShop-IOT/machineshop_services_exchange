class CreateStyles < ActiveRecord::Migration
  def change
    create_table :styles do |t|
      t.string :name
      t.string :link_color
      t.string :link_hover_color
      t.string :font_type
      t.string :background_color
      t.string :font_color
      t.string :user_id
      t.timestamps
    end
  end
end
