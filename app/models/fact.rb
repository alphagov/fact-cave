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

class CurrencyFact < Fact
  field :currency_code, :type => String
  field :value, :type => BigDecimal
 
  attr_accessible :currency_code
 
  validate :valid_currency_code
  validates_numericality_of :value

  def self.currency_codes
    currency_data['currency_codes']
  end
 
  def self.currency_symbols
    currency_data['currency_symbols']
  end

  private

  def valid_currency_code
    unless self.class.currency_codes.values.include?(currency_code)
      errors.add(:currency_code, "Currency code is invalid")
    end
  end

  def self.currency_data
    @currency_data ||= YAML.load(File.open("lib/data/iso_4217_currency_codes.yml").read)  
  end
end

class NumericFact < Fact
  field :unit, :type => String
  field :value, :type => Float
  attr_accessible :unit
  validates_numericality_of :value
end

class DateFact < Fact
  field :value, :type => DateTime
end
