require 'spec_helper'

feature "serving facts" do

  it "should return a JSON object of an existing fact" do
    fact = FactoryGirl.create(:fact, name: "VAT rate", description: "The national VAT rate",
                    value: "20", slug: "vat-rate", data_type: "numeric", numeric_format: "percentage")

    get "/facts/vat-rate"
    response.should be_success
    fact_response = JSON.load(response.body)

    fact_response.should == {
      "_response_info" => {"status"=>"ok"},
      "id" => "http://www.example.com/facts/vat-rate",
      "details" => {
        "description" => "The national VAT rate",
        "value" => "20",
        "formatted_value" => "20%"
      },
      "name" => "VAT rate",
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
