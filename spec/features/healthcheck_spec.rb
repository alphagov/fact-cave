require 'spec_helper'

feature "The healthcheck URL" do

  it "should return a basic string" do
    visit "/healthcheck"

    page.should have_content("OK")
  end
end
