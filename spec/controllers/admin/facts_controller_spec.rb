# encoding: UTF-8
require 'spec_helper'

describe Admin::FactsController do

  describe "non editorial actions" do

    before do
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
  end

  describe "editorial actions" do
    before(:each) do
      login_as_stub_editor
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
          :description => "The truth hurts sometimes", :value => "Life's not fair"
        }
        response.status.should == 302
        fact = Fact.find_by(:slug => 'the-painful-truth')
        fact.name.should == 'The painful truth'
      end
      it "should save a currency fact" do
        post :create, :currency_fact => {
          :slug => "uk-tax-disc", :name => "UK tax disc",
          :description => "Price of a tax disc", :value => 199.99,
          :currency_code => 'GBP'
        }
        response.status.should == 302
        fact = CurrencyFact.find_by(:slug => 'uk-tax-disc')
        fact.name.should == 'UK tax disc'
        fact.value.should == BigDecimal('199.99')
        fact.currency_code.should == 'GBP'
      end
      it "should save a date fact" do
        post :create, :date_fact => {
          :slug => "battle-of-hastings", :name => "Battle of Hastings",
          :description => "The date of the Battle of Hastings", :value => "14 Oct 1066"
        }
        response.status.should == 302
        fact = DateFact.find_by(:slug => 'battle-of-hastings')
        fact.name.should == 'Battle of Hastings'
        fact.value.should == DateTime.parse('14 Oct 1066')
      end
      it "should save a numeric fact" do
        post :create, :numeric_fact => {
          :slug => 'life-the-universe-and-everything', :name => 'Life the universe and everything',
          :description => 'The answer to the ultimate question of life, the universe and everything',
          :value => '42'
        }
        response.status.should == 302
        fact = NumericFact.find_by(:slug => 'life-the-universe-and-everything')
        fact.value.should == 42.0
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
        @fact = FactoryGirl.create(:currency_fact)
      end
      it "should update a fact" do
        put :update, :id => @fact.to_param, :fact => {
          :slug => "the-painful-truth", :name => "The painful truth",
          :description => "The truth hurts sometimes", :value => "1000000",
          :currency_code => "EUR"
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

  describe "performing actions without permission" do
    before(:each) do
      login_as_stub_user
      @fact = FactoryGirl.create(:numeric_fact)
    end
    describe "GET new" do
      it "should deny access and redirect" do
        get :new
        response.should redirect_to(admin_facts_path)
      end
    end
    describe "POST create" do
      it "should deny access and redirect" do
        post :create, :currency_fact => {
          :slug => "uk-tax-disc", :name => "UK tax disc",
          :description => "Price of a tax disc", :value => 199.99,
          :currency_code => 'GBP'
        }
        response.should redirect_to(admin_facts_path)
      end
    end
    describe "GET edit" do
      it "should deny access and redirect" do
        get :edit, :id => @fact.to_param
        response.should redirect_to(admin_facts_path)
      end
    end
    describe "PUT update" do
      it "should deny access and redirect" do
        put :update, :id => @fact.to_param, :fact => {
          :slug => "the-painful-truth", :name => "The painful truth",
          :description => "The truth hurts sometimes", :value => "1000000",
          :currency_code => "EUR"
        }
        response.should redirect_to(admin_facts_path)
      end
    end
    describe "DELETE destroy" do
      it "should deny access and redirect" do
        delete :destroy, :id => @fact.to_param
        response.should redirect_to(admin_facts_path)
      end
    end
  end
end
