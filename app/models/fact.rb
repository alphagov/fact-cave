class Fact
  include MongoMapper::Document

  key :name, String
  key :slug, String
  key :description, String
  key :value, String
  timestamps!

  ensure_index [[:slug, 1]], :unique => true

  attr_accessible :description, :name, :value, :slug

  validates_presence_of :name, :value, :slug
  validates :slug, :uniqueness => true, :format => {:with => /\A[a-z0-9-]*\z/}
end
