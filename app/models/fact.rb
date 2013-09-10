# encoding: UTF-8

class Fact
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :slug, :type => String
  field :description, :type => String
  field :value, :type => String
  field :numeric_format, :type => String
  field :currency_code, :type => String, :default => 'GBP'

  index({:slug => 1}, {:unique => true})

  attr_accessible :description, :name, :value, :slug

  validates_presence_of :name, :value, :slug
  validates :slug, :uniqueness => true, :format => {:with => /\A[a-z0-9-]*\z/}

end

class CurrencyFact < Fact
  CURRENCY_SYMBOLS = { :eur => "€", :gbp => "£", :usd => "$", :cny => "¥", :jpy => "¥" }
  field :currency_code, :type => String
  field :value, :type => BigDecimal
  validates_presence_of :currency_code
  attr_accessible :currency_code
end

class NumericFact < Fact
  field :unit, :type => String
  field :value, :type => Float
  attr_accessible :unit
end

class DateFact < Fact
  field :value, :type => DateTime
end
