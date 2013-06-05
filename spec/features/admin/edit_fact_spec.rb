require 'spec_helper'

feature "creating a fact" do

  before :each do
    login_as_stub_user

    @fact = FactoryGirl.create(:fact,
                              :name => 'Fact of the day',
                              :slug => 'fact-of-the-day',
                              :description => 'Only true for a day',
                              :value => 'Today is Wednesday')
  end

  it "should display a table of existing facts" do

    visit "/admin/facts"

    within('table tr', :text => 'Fact of the day') do
      click_on 'Edit'
    end

    current_path.should == "/admin/facts/#{@fact.to_param}/edit"

    within('form') do
      
      page.should have_field 'Name', :with => 'Fact of the day'
      page.should have_field 'Slug', :with => 'fact-of-the-day'
      page.should have_field 'Description', :with => 'Only true for a day'
      page.should have_field 'Value', :with => 'Today is Wednesday'
      page.should have_button 'Update Fact'

      fill_in 'Name', :with => 'Factoid'
      fill_in 'Slug', :with => 'factoid'
      fill_in 'Description', :with => 'This is a factiod'
      fill_in 'Value', :with => 'Factoids are small truths which float around a larger fact'
      click_on 'Update Fact'
    end

    current_path.should == '/admin/facts'

    page.should have_content 'Factoid'
    page.should have_content 'Fact updated'
  end

end
