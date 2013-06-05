require 'spec_helper'

feature "listing facts" do

  before :each do
    login_as_stub_user
    
    3.times do |n| 
      count = n + 1
      FactoryGirl.create(:fact, :slug => "fact-#{count}", 
                         :name => "Fact #{count}", :value => "value-#{count}")
    end
  end

  it "should display a table of existing facts" do

    visit "/admin/facts"

    within('table tr', :text => 'Fact 1') do
      page.should have_content 'Fact 1'
      page.should have_content 'fact-1'
      page.should have_content 'value-1'
      page.should have_link 'Edit'
      page.should have_button 'Delete'
    end
    within('table tr', :text => 'Fact 2') do
      page.should have_content 'Fact 2'
      page.should have_content 'fact-2'
      page.should have_content 'value-2'
      page.should have_link 'Edit'
      page.should have_button 'Delete'
    end
    within('table tr', :text => 'Fact 3') do
      page.should have_content 'Fact 3'
      page.should have_content 'fact-3'
      page.should have_content 'value-3'
      page.should have_link 'Edit'
      page.should have_button 'Delete'
    end

    page.should have_link 'New Fact'

    click_on 'New Fact'

    current_path.should == '/admin/facts/new'
  end

end
