class AddAttachmentFileToWhitePapers < ActiveRecord::Migration
  def self.up
    change_table :white_papers do |t|
      t.has_attached_file :file
    end
  end

  def self.down
    drop_attached_file :white_papers, :file
  end
end
