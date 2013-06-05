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
      expect(fact.errors[:name]).not_to be_blank
    end

    describe "on slug" do
      it "should be required" do
        fact.slug = ''
        expect(fact).not_to be_valid
        expect(fact.errors[:slug]).not_to be_blank
      end

      it "should be unique" do
        fact2 = FactoryGirl.create(:fact, :slug => 'a-fact')
        fact.slug = 'a-fact'
        expect(fact).not_to be_valid
        expect(fact.errors[:slug]).not_to be_blank
      end
    end
  end
end
