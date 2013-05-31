require 'spec_helper'

feature "The root URL" do

  it "should return a basic string" do
    visit "/"

    page.should have_content("Fact Cave")
  end
end
