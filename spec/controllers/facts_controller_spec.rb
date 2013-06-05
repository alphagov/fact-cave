require 'spec_helper'

describe FactsController do
  describe "GET show" do
    it "should have an HTTP status of 404 if the fact is NOT present" do
      get :show, slug: "this-does-not-exist-yet"
      response.should be_missing
    end

    it "should have an HTTP status of OK if the fact is present" do
      @fact = FactoryGirl.create(:fact, :slug => 'vat-rate')
      get :show, slug: @fact.slug
      response.should be_success
    end
  end
end
