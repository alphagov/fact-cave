require 'spec_helper'

feature "The root URL" do

  before :each do
    #login_as_stub_user
  end

  it "should return a basic string" do
    visit "/"

    page.should have_content("Fact Cave")
  end
end
