require 'spec_helper'

feature "getting a single fact" do
  it "should have an HTTP status of OK" do
    fact = Fact.new(name: "VAT rate", description: "The national VAT rate",
                    value: "20%", slug: "vat-rate")
    fact.save

    visit "/facts/vat-rate"

    page.status_code.should == 200
    page.body.should have_content(fact.name)
    page.body.should have_content(fact.slug)
    page.body.should have_content(fact.description)
    page.body.should have_content(fact.value)
  end
end
