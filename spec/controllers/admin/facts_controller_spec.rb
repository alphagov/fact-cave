require 'spec_helper'

describe Admin::FactsController do

  before :each do
    login_as_stub_user
  end

  describe "GET to index" do
    it "displays 'Fact Cave'" do
      get :index
      response.status.should == 200
      response.body.should == "Fact Cave"
    end
  end

end
