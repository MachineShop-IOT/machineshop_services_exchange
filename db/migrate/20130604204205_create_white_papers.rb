class CreateWhitePapers < ActiveRecord::Migration
  def change
    create_table :white_papers do |t|
    	t.string :title
    	t.text :description

      t.timestamps
    end
  end
end
