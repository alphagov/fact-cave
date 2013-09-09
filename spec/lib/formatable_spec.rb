# encoding: UTF-8
require 'spec_helper'

include Formattable

describe Formattable do
  describe "formatted_value" do
    let(:fact) { FactoryGirl.build(:fact) }
    describe "when data_type is not implemented" do
      before do
        class Foo
          include Formattable
        end
      end
      it "should raise an error" do
        expect { Foo.new.formatted_value }.to raise_error("Including class must implement 'data_type' attribute or method")
      end
    end
    describe "for currency data type" do
      it "should default to Pound Sterling" do
        fact.value = '99'
        fact.data_type = 'currency'
        expect(fact.currency_code).to eq("GBP")
      end
      it "should use the currency symbol when present" do
        fact.value = '10000'
        fact.data_type = 'currency'
        fact.currency_code = 'EUR'
        expect(fact.formatted_value).to eq("€10,000")
      end
      it "should use the name as a suffix if no currency symbol is present" do
        fact.value = '1000'
        fact.data_type = 'currency'
        fact.currency_code = 'ZAR'
        expect(fact.formatted_value).to eq("1,000 Rand")
      end
    end
    describe "for date data type" do
      it "should format the date as yyyy-MM-dd" do
        fact.value = '7 Sept 2013'
        fact.data_type = 'date'
        expect(fact.formatted_value).to eq("2013-09-07")
      end
    end
    describe "for numeric data type" do
      it "should delimit the value with commas as per the style guide" do
        fact.value = '10000000'
        fact.data_type = 'numeric'
        expect(fact.formatted_value).to eq("10,000,000")
      end
    end
    it "should use formatting symbols where present" do
      fact.value = '42'
      fact.data_type = 'numeric'
      fact.numeric_format = 'percentage'
      expect(fact.formatted_value).to eq("42%")
    end
  end
  describe "currency codes data" do
    it "should be a hash of ISO 4217 currency codes" do
      expect(Formattable.currency_codes["Euro"]).to eq("EUR")
      expect(Formattable.currency_codes["Pound Sterling"]).to eq("GBP")
      expect(Formattable.currency_codes["US Dollar"]).to eq("USD")
    end
  end
  describe "numeric formats" do
    it "should be a hash of numeric formats" do
      expect(Formattable::NUMERIC_FORMATS[:percentage]).to eq("%d%")
    end
  end
end
