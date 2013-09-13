require 'spec_helper'

feature "deleting a fact" do

  before :each do
    login_as_stub_editor
    
    3.times { |n| FactoryGirl.create(:fact, :slug => "fact-#{n + 1}", :name => "Fact #{n + 1}") }
  end

  it "should display a table of existing facts" do

    visit "/admin"

    within('table tr', :text => 'Fact 1') do
      page.should have_button 'Delete'
      click_on 'Delete'
    end
   
    within('table') do
      page.should have_no_content 'Fact 1'
    end
    
    page.should have_content 'Fact 1 deleted'
  end

end
