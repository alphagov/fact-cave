class Fact
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :slug, :type => String
  field :description, :type => String
  field :value, :type => String

  index({:slug => 1}, {:unique => true})

  attr_accessible :description, :name, :value, :slug

  validates_presence_of :name, :value, :slug
  validates :slug, :uniqueness => true, :format => {:with => /\A[a-z0-9-]*\z/}
end
