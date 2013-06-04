require 'spec_helper'

describe Fact do
  describe "building out a fact" do
    it "requires a name, description and a value" do
      fact = Fact.new
      fact.should_not be_valid
    end

    it "should build out a fact when given the correct fields" do
      fact = Fact.new(name: "Test", description: "This is a test fact", value: 23)
      fact.should be_valid
    end

    it "should be persisted" do
      fact = Fact.new(name: "Test", description: "This is a test fact", value: 23)
      fact.save
      fact.should be_persisted
    end
  end
end
