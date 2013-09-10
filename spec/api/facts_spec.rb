# encoding: UTF-8
require 'spec_helper'

feature "serving facts" do

  it "should return a JSON object of an existing numeric fact" do
    fact = FactoryGirl.create(:numeric_fact, name: "VAT rate", description: "The national VAT rate",
                    value: 20, slug: "vat-rate", unit: "%")

    get "/facts/vat-rate"
    response.should be_success
    fact_response = JSON.load(response.body)

    fact_response.should == {
      "_response_info" => {"status"=>"ok"},
      "id" => "http://www.example.com/facts/vat-rate",
      "details" => {
        "description" => "The national VAT rate",
        "value" => 20.0,
        "formatted_value" => "20%"
      },
      "name" => "VAT rate",
      "updated_at" => fact.updated_at.xmlschema
    }
  end

  it "should return a JSON object of an existing numeric fact with no unit formatting" do
    fact = FactoryGirl.create(:numeric_fact, name: "How many years in a millenia", description: "How many years in a millenia",
                    value: 1000, slug: "years-in-a-millenia", unit: nil)

    get "/facts/years-in-a-millenia"
    response.should be_success
    fact_response = JSON.load(response.body)

    fact_response.should == {
      "_response_info" => {"status"=>"ok"},
      "id" => "http://www.example.com/facts/years-in-a-millenia",
      "details" => {
        "description" => "How many years in a millenia",
        "value" => 1000.0,
        "formatted_value" => "1,000"
      },
      "name" => "How many years in a millenia",
      "updated_at" => fact.updated_at.xmlschema
    }
  end

  it "should return a JSON object of an existing currency fact" do
    fact = FactoryGirl.create(:currency_fact, name: "Vehicle excise duty", description: "How much a tax disc costs",
                    value: 180, slug: "uk-tax-disc", currency_code: 'GBP')

    get "/facts/uk-tax-disc"
    response.should be_success
    fact_response = JSON.load(response.body)

    fact_response.should == {
      "_response_info" => {"status"=>"ok"},
      "id" => "http://www.example.com/facts/uk-tax-disc",
      "details" => {
        "description" => "How much a tax disc costs",
        "value" => "180.0",
        "formatted_value" => "£180.00"
      },
      "name" => "Vehicle excise duty",
      "updated_at" => fact.updated_at.xmlschema
    }
  end

  it "should return a JSON object of an existing date fact" do
    fact = FactoryGirl.create(:date_fact, name: "Battle of Hastings", description: "The date of the Battle of Hastings",
                    value: Date.parse('14 Oct 1066'), slug: "battle-of-hastings")

    get "/facts/battle-of-hastings"
    response.should be_success
    fact_response = JSON.load(response.body)

    fact_response.should == {
      "_response_info" => {"status"=>"ok"},
      "id" => "http://www.example.com/facts/battle-of-hastings",
      "details" => {
        "description" => "The date of the Battle of Hastings",
        "value" => '1066-10-14T00:00:00+00:00',
        "formatted_value" => "1066-10-14"
      },
      "name" => "Battle of Hastings",
      "updated_at" => fact.updated_at.xmlschema
    } 
  end

  it "should return a JSON object of an existing text fact" do
    fact = FactoryGirl.create(:fact, name: "Limitations of canine vision", description: "The truth about dogs",
                    value: "Dogs can't look up", slug: "canine-vision-limitations")

    get "/facts/canine-vision-limitations"
    response.should be_success
    fact_response = JSON.load(response.body)

    fact_response.should == {
      "_response_info" => {"status"=>"ok"},
      "id" => "http://www.example.com/facts/canine-vision-limitations",
      "details" => {
        "description" => "The truth about dogs",
        "value" => "Dogs can't look up",
        "formatted_value" => "Dogs can't look up"
      },
      "name" => "Limitations of canine vision",
      "updated_at" => fact.updated_at.xmlschema
    }   
  end

  it "should return an appropriate id URL when requested through the public API" do
    Plek.any_instance.stub(:website_root).and_return("https://www.gov.uk")
    fact = FactoryGirl.create(:fact, slug: "vat-rate")

    get "/facts/vat-rate", nil, {"HTTP_API_PREFIX" => "api"}
    response.should be_success
    fact_response = JSON.load(response.body)

    fact_response["id"].should == "https://www.gov.uk/api/facts/vat-rate"
  end
end
