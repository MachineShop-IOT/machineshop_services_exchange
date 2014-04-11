class AddAttachmentImageToExampleApplications < ActiveRecord::Migration
  def self.up
    change_table :example_applications do |t|
      t.has_attached_file :image
    end
  end

  def self.down
    drop_attached_file :example_applications, :image
  end
end
