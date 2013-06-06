require 'spec_helper'

describe ApplicationHelper do
  before :each do
    @fact = Fact.new
    @fact.valid?
  end
  describe "error_css" do
    it "should return a css error class if the field has errors" do
      error_css(@fact, :name, 'foo').should == ' foo'
    end
    it "should return an empty string if no error exists on the field" do
      @fact.name = "Fact"
      @fact.valid?
      error_css(@fact, :name, 'foo').should == ''
    end
    it "should return an empty string if the field doesn't exist" do
      error_css(@fact, :meep, 'foo').should == ''
    end
  end
  describe "error_message_for_field" do
    it "should return error html for a field with errors" do
      error_message_for_field(@fact, :slug).should == %Q(<span class="help-inline">can't be blank</span>)
    end
  end
  describe "error_message_for_field" do
    it "should return an empty string for a field with no errors" do
      error_message_for_field(@fact, :description).should == ''    
    end
  end
end
