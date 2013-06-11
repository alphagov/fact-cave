require 'spec_helper'

feature "serving facts" do

  it "should return a JSON object of an existing fact" do
    fact = FactoryGirl.create(:fact, name: "VAT rate", description: "The national VAT rate",
                    value: "20%", slug: "vat-rate")

    get "/facts/vat-rate"
    response.should be_success
    fact_response = JSON.load(response.body)

    fact_response.should == {
      "_response_info" => {"status"=>"ok"},
      "id" => "vat-rate",
      "details" => {
        "description" => "The national VAT rate",
        "value" => "20%"
      },
      "title" => "VAT rate",
      "updated_at" => fact.updated_at.xmlschema
    }
  end
end
