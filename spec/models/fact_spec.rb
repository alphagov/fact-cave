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

  describe "data types" do
    it "should be an array of permitted types" do
      expect(Fact::DATA_TYPES).to eq([:currency, :date, :numeric, :text])
    end
  end

end
