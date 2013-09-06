# encoding: UTF-8
require 'spec_helper'

describe Fact do
  describe "validations" do
    let(:fact) { FactoryGirl.build(:fact) }

    it "should be valid by default" do
      expect(fact).to be_valid
    end

    it "should require a name" do
      fact.name = ''
      expect(fact).not_to be_valid
      expect(fact).to have(1).error_on(:name)
    end

    describe "on slug" do
      it "should be required" do
        fact.slug = ''
        expect(fact).not_to be_valid
        expect(fact).to have(1).error_on(:slug)
      end

      it "should be unique" do
        fact2 = FactoryGirl.create(:fact, :slug => 'a-fact')
        fact.slug = 'a-fact'
        expect(fact).not_to be_valid
        expect(fact).to have(1).error_on(:slug)
      end

      it "should have a db level uniqueness constraint" do
        fact2 = FactoryGirl.create(:fact, :slug => 'a-fact')
        fact.slug = 'a-fact'
        expect(lambda { fact.save :validate => false }).to raise_error(Moped::Errors::OperationFailure)
      end

      it "should look like a slug" do
        [
          'a space',
          'under_score',
          'full.stop',
          'this&that',
        ].each do |slug|
          fact.slug = slug
          expect(fact).not_to be_valid
          expect(fact).to have(1).error_on(:slug)
        end
      end
    end
    it "should require a data type" do
      fact.data_type = ''
      expect(fact).not_to be_valid
      expect(fact).to have(1).error_on(:data_type)
    end
  end
  describe "formatted_value" do
    let(:fact) { FactoryGirl.build(:fact) }
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
  describe "data types" do
    it "should be an array of permitted types" do
      expect(Fact::DATA_TYPES).to eq([:currency, :date, :numeric, :text])
    end
  end
  describe "numeric formats" do
    it "should be a hash of numeric formats" do
      expect(Fact::NUMERIC_FORMATS[:percentage]).to eq("%d%")
    end
  end
  describe "currency codes data" do
    it "should be a hash of ISO 4217 currency codes" do
      expect(Fact.currency_codes["Euro"]).to eq("EUR")
      expect(Fact.currency_codes["Pound Sterling"]).to eq("GBP")
      expect(Fact.currency_codes["US Dollar"]).to eq("USD")
    end
  end
end
