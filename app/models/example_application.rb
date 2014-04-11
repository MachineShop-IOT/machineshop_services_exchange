class ExampleApplication < ActiveRecord::Base
  attr_accessible :title, :description, :image, :url
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
