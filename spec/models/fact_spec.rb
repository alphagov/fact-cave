require 'spec_helper'

describe Fact do
  describe "building out a fact" do
    it "requires a name, description and a value" do
      fact = Fact.new
      fact.should_not be_valid
    end

    it "should build out a fact when given the correct fields" do
      fact = Fact.new(name: "Test", description: "This is a test fact",
                      value: 23, slug: "test")
      fact.should be_valid
    end

    it "should be persisted" do
      fact = Fact.new(name: "Test", description: "This is a test fact",
                      value: 23, slug: "test")
      fact.save
      fact.should be_persisted
    end

    it "should have unique slugs" do
      fact = Fact.new(name: "VAT rate", description: "The national VAT rate",
                      value: "20%", slug: "vat-rate")
      fact.save
      fact2 = Fact.new(name: "VAT rate", description: "The national VAT rate",
                       value: "20%", slug: "vat-rate")
      fact2.save

      fact.should be_persisted
      fact2.should_not be_persisted
    end
  end
end
