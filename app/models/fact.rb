class Fact
  include Mongoid::Document
  include Mongoid::Timestamps

  DATA_TYPES = [:currency, :date, :numeric, :text]
  
  field :name, :type => String
  field :slug, :type => String
  field :description, :type => String
  field :value, :type => String
  field :data_type, :type => String

  index({:slug => 1}, {:unique => true})

  attr_accessible :description, :name, :value, :slug, :data_type

  validates_presence_of :name, :value, :slug
  validates_inclusion_of :data_type, :in => DATA_TYPES.map(&:to_s)
  validates :slug, :uniqueness => true, :format => {:with => /\A[a-z0-9-]*\z/}

end
