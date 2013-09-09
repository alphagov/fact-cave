# encoding: UTF-8
module Formattable
 
  include ActionView::Helpers::NumberHelper
  
  NUMERIC_FORMATS = { :percentage => "%d%" }
  
  CURRENCY_SYMBOLS = {
    :eur => "€",
    :gbp => "£",
    :usd => "$",
    :cny => "¥",
    :jpy => "¥"
  }

  def formatted_value
    send(:"formatted_#{data_type}_value")
  rescue NameError
    raise "Including class must implement 'data_type' attribute or method"
  end

  def self.currency_codes
    @currency_codes ||= YAML.load(File.open("lib/data/iso_4217_currency_codes.yml").read)  
  end
  
  private

  def formatted_currency_value
    currency_symbol = CURRENCY_SYMBOLS[currency_code.downcase.to_sym]
    amount = number_with_delimiter(value)
    if currency_symbol
      "#{currency_symbol}#{amount}"
    else
      "#{amount} #{Formattable.currency_codes.key(currency_code)}"
    end
  end

  def formatted_date_value
    Date.parse(value).strftime("%Y-%m-%d")
  end

  def formatted_numeric_value
    if numeric_format.nil?
      number_with_delimiter(value)
    else
      format = NUMERIC_FORMATS[numeric_format.to_sym]
      number_with_delimiter(sprintf(format, value))
    end
  end

  def formatted_text_value
    value
  end 
end
