require 'spec_helper'

describe Admin::FactsController do

  before :each do
    login_as_stub_user
  end

  describe "GET index" do
    before do
      @fact = FactoryGirl.create(:fact)
    end
    it "displays facts" do
      get :index
      response.status.should == 200
      assigns(:facts).first.should == @fact
    end
  end

  describe "GET new" do
    it "should initialize a fact" do
      get :new
      response.status.should == 200
      assigns(:fact).class.should == Fact
      assigns(:fact).should be_new_record
    end
  end

  describe "POST create" do
    it "should save a fact" do
      post :create, :fact => {
        :slug => "the-painful-truth", :name => "The painful truth",
        :description => "The truth hurts sometimes", :value => "Life's not fair",
        :data_type => "text"
      }
      response.status.should == 302
      Fact.find_by(:slug => 'the-painful-truth').name.should == 'The painful truth'
    end
  end

  describe "GET edit" do
    before do
      @fact = FactoryGirl.create(:fact)
    end
    it "should retrieve a fact to edit" do
      get :edit, :id => @fact.to_param
      response.status.should == 200
      assigns(:fact).should == @fact
    end
  end

  describe "PUT update" do
    before do
      @fact = FactoryGirl.create(:fact)
    end
    it "should update a fact" do
      put :update, :id => @fact.to_param, :fact => {
        :slug => "the-painful-truth", :name => "The painful truth",
        :description => "The truth hurts sometimes", :value => "Life's not fair" 
      }
      response.status.should == 302 
      assigns(:fact).should == @fact
    end
  end

  describe "DELETE destroy" do
    before do
      @fact = FactoryGirl.create(:fact)
    end
    it "should delete a fact" do
      delete :destroy, :id => @fact.to_param
      assigns(:fact).should == @fact
      expect { Fact.find(@fact.to_param) }.to raise_error
    end
  end

end
