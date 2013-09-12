# encoding: UTF-8
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

    def post_create
      params = { fact: @valid_params }
      post :create, params
    end

    describe "logging" do
      before :each do
        created_at = DateTime.now
        Fact.any_instance.stub(:created_at).and_return(created_at)
        @valid_params = {
          slug:  "the-painful-truth", name: "The painful truth",
          description: "The truth hurts sometimes", value: "Life's not fair"
        }
        @expected =
          {
            "@fields" => {
              "event_type" => "create",
              "fact_data" => {
                "_type" => "Fact",
                "slug" => @valid_params[:slug],
                "name" => @valid_params[:name],
                "description" => @valid_params[:description],
                "value" => @valid_params[:value]
              },
              "message" => "Fact created at #{created_at}"
            }
          }
      end

      it "should send details about the created fact for logging" do
        controller.should_receive(:write_log).with(@expected)
        post_create
      end

      it "should attempt to write a JSON log entry to file" do
        file = mock File
        File.stub(:open).and_yield(file)
        file.should_receive(:puts).with(@expected.to_json)
        post_create
      end

      it "should not attempt to log an invalid fact" do
        controller.should_not_receive(:write_log)
        @valid_params.merge!(name: '')
        post_create
      end
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

  def put_update
    params = { id: @fact.to_param, fact: @valid_params }
    put :update, params
  end

  describe "PUT update" do
    before do
      @fact = FactoryGirl.create(:currency_fact, description: "")
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

    describe "logging" do
      before :each do
        updated_at = DateTime.now
        Fact.any_instance.stub(:updated_at).and_return(updated_at)
        @valid_params = {
          slug:  "the-painful-truth", name: "The painful truth",
          description: "The truth hurts sometimes", value: "1000000",
          data_type: "currency", currency_code: "EUR"
        }
        @expected =
          {
            "@fields" => {
              "event_type" => "update",
              "fact_data" => {
                "before_state" => {
                  "_type" => "CurrencyFact",
                  "slug" => @fact[:slug],
                  "name" => @fact[:name],
                  "value" => @fact[:value],
                  "currency_code" => @fact[:currency_code],
                  "description" => @fact[:description],
                },
                "changes" => {
                  "slug" => @valid_params[:slug],
                  "name" => @valid_params[:name],
                  "value" => @valid_params[:value],
                  "currency_code" => @valid_params[:currency_code],
                  "description" => @valid_params[:description]
                }
              },
              "message" => "CurrencyFact updated at #{updated_at}"
            }
          }
      end

      it "should send details about the updated fact for logging" do
        controller.should_receive(:write_log).with(@expected)
        put_update
      end

      it "should attempt to write a JSON log entry to file" do
        file = mock File
        File.stub(:open).and_yield(file)
        file.should_receive(:puts).with(@expected.to_json)
        put_update
      end

      it "should not attempt to log an invalid fact" do
        controller.should_not_receive(:write_log)
        @valid_params.merge!(name: '')
        put_update
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @fact = FactoryGirl.create(:fact, description: '')
    end
    it "should delete a fact" do
      delete :destroy, :id => @fact.to_param
      assigns(:fact).should == @fact
      expect { Fact.find(@fact.to_param) }.to raise_error
    end

    describe "logging" do
      before :each do
        destroyed_at = DateTime.now
        @expected =
          {
            "@fields" => {
              "event_type" => "destroy",
              "fact_data" => {
                  "_type" => "Fact",
                  "slug" => @fact[:slug],
                  "name" => @fact[:name],
                  "value" => @fact[:value],
                  "description" => @fact[:description]
                },
              "message" => "Fact destroyed at #{destroyed_at}"
            }
          }
      end

      it "should send details about the destroyed fact for logging" do
        controller.should_receive(:write_log).with(@expected)
        delete :destroy, :id => @fact.to_param
      end

      it "should attempt to write a JSON log entry to file" do
        file = mock File
        File.stub(:open).and_yield(file)
        file.should_receive(:puts).with(@expected.to_json)
        delete :destroy, :id => @fact.to_param
      end

      it "should not attempt to log a fact that can't be detroyed" do
        Fact.any_instance.stub(:destroyed?).and_return(false)
        delete :destroy, :id => @fact.to_param
      end
    end
  end
end
