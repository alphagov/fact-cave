# encoding: UTF-8

class Fact
  include Mongoid::Document
  include Mongoid::Timestamps

  DATA_TYPES = [:currency, :date, :numeric, :text]
  NUMERIC_FORMATS = { :percentage => '%' }
  
  CURRENCY_SYMBOLS = {
    :eur => "€",
    :gbp => "£",
    :usd => "$"
  }


  field :name, :type => String
  field :slug, :type => String
  field :description, :type => String
  field :value, :type => String
  field :data_type, :type => String
  field :numeric_format, :type => String
  field :currency_code, :type => String

  index({:slug => 1}, {:unique => true})

  attr_accessible :description, :name, :value, :slug, :data_type, :numeric_format, :currency_code

  validates_presence_of :name, :value, :slug
  validates_inclusion_of :data_type, :in => DATA_TYPES.map(&:to_s)
  validates :slug, :uniqueness => true, :format => {:with => /\A[a-z0-9-]*\z/}

  def formatted_value
    send(:"formatted_#{data_type}_value")
  end

  def self.currency_codes
    @currency_codes ||= YAML.load(File.open("lib/data/iso_4217_currency_codes.yml").read)  
  end
  
  private

  def formatted_currency_value
    currency_symbol = CURRENCY_SYMBOLS[currency_code.downcase.to_sym]
    if currency_symbol
      "#{currency_symbol}#{value}"
    else
      "#{value} #{self.class.currency_codes.key(currency_code)}"
    end
  end

  def formatted_date_value
    Date.parse(value).strftime("%Y-%m-%d")
  end

  def formatted_numeric_value
    value
  end

  def formatted_text_value
    value
  end

end
