require 'spec_helper'

describe FactsController do
  describe "GET show" do
    before do
      @fact = Fact.new(name: "VAT Rate", description: "A value added tax (VAT) is a form of consumption tax",
                       value: "20%", slug: "vat-rate")
      @fact.save
    end

    it "should have an HTTP status of 404 if the fact is NOT present" do
      get :show, slug: "this-does-not-exist-yet"
      response.should be_missing
    end

    it "should have an HTTP status of OK if the fact is present" do
      get :show, slug: @fact.slug
      response.should be_success
    end
  end
end
