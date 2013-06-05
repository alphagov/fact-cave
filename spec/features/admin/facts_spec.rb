require 'spec_helper'

feature "listing facts" do

  before :each do
    login_as_stub_user
    
    3.times { |n| FactoryGirl.create(:fact, :slug => "fact-#{n + 1}", :name => "Fact #{n + 1}") }
  end

  it "should display a table of existing facts" do

    visit "/admin"

    within('table') do
      page.should have_content 'Fact 1'
      page.should have_content 'Fact 2'
      page.should have_content 'Fact 3'
    end
  end

end
