require 'spec_helper'

feature "getting a single fact" do
  it "should return a JSON object of an existing fact" do
    fact = Fact.new(name: "VAT rate", description: "The national VAT rate",
                    value: "20%", slug: "vat-rate")
    fact.save

    visit "/facts/vat-rate"
    fact_response = JSON.load(page.body)

    page.status_code.should == 200
    fact_response.slice("name", "description", "slug", "value").should == {
      "name" => "VAT rate",
      "description" => "The national VAT rate",
      "slug" => "vat-rate",
      "value" => "20%"
    }
  end
end
