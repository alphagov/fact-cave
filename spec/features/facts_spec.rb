require 'spec_helper'

feature "serving facts" do

  it "should return a JSON object of an existing fact" do
    fact = Fact.new(name: "VAT rate", description: "The national VAT rate",
                    value: "20%", slug: "vat-rate")
    fact.save

    visit "/facts/vat-rate"
    fact_response = JSON.load(page.body)

    page.status_code.should == 200
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
