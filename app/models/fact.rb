class Fact < ActiveRecord::Base
  attr_accessible :description, :name, :value, :slug

  validates_presence_of :name, :value, :slug
  validates :slug, :uniqueness => true
end
