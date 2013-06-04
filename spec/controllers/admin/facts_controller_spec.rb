require 'spec_helper'

describe Admin::FactsController do

  describe "GET to index" do
    it "displays 'Fact Cave'" do
      get :index
      response.status.should == 200
      response.body.should == "Fact Cave"
    end
  end

end
