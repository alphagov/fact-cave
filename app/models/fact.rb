class Fact < ActiveRecord::Base
  attr_accessible :description, :name, :value, :slug

  validates_presence_of :name, :value, :slug
  validates :slug, :uniqueness => true, :format => {:with => /\A[a-z0-9-]*\z/}
end
