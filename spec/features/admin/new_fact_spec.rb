require 'spec_helper'

feature "creating a fact" do

  before :each do
    login_as_stub_user
  end

  it "should display a table of existing facts" do

    visit "/admin/facts/new"

    within('form') do
      
      page.should have_field 'Name'
      page.should have_field 'Slug'
      page.should have_field 'Description'
      page.should have_field 'Value'
      page.should have_button 'Create Fact'

      fill_in 'Name', :with => 'Factoid'
      fill_in 'Slug', :with => 'factoid'
      fill_in 'Description', :with => 'This is a factiod'
      fill_in 'Value', :with => 'Factoids are small truths which float around a larger fact'
      click_on 'Create Fact'
    end

    current_path.should == '/admin/facts'

    page.body.should have_content 'Factoid'
  end

end
