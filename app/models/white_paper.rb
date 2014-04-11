class WhitePaper < ActiveRecord::Base
  attr_accessible :title, :description, :file
  has_attached_file :file, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :file, presence: true
end
