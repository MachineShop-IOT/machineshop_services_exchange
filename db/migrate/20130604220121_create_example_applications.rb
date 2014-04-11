class CreateExampleApplications < ActiveRecord::Migration
  def change
    create_table :example_applications do |t|
    	t.string :title
    	t.text :description
    	t.string :url

      t.timestamps
    end
  end
end
