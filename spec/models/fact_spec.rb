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
  end
end

describe CurrencyFact do
  let(:fact) { FactoryGirl.build(:currency_fact) }
  it "should store a BigDecimal value" do
    expect(fact.value.class).to be(BigDecimal)
  end
  it "should have a currency code" do
    expect(fact.currency_code).to eq('GBP')
  end
  it "should validate the presence of a currency code" do
    fact.currency_code = nil
    fact.valid?
    expect(fact).to have(1).error_on(:currency_code)
  end
  it "should validate numericality of value" do
    fact.value = 'foo'
    expect(fact).not_to be_valid
  end
end 

describe DateFact do
  it "should store a DateTime value" do
    fact = FactoryGirl.build(:date_fact)
    expect(fact.value.class).to be(DateTime)
  end
end

describe NumericFact do
  let(:fact) { FactoryGirl.build(:numeric_fact) }
  it "should store a Float value" do
    expect(fact.value.class).to be(Float)
  end
  it "can hold a formatting symbol" do
    expect(fact.unit).to eq('%')
  end
  it "should validate numericality of value" do
    fact.value = 'foo'
    expect(fact).not_to be_valid
    expect(fact).to have(1).error_on(:value)
  end
end
