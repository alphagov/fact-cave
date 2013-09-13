require 'spec_helper'

feature "editing a fact" do

  before :each do
    login_as_stub_editor

    @fact = FactoryGirl.create(:currency_fact,
                              :name => 'Vehicle excise duty',
                              :slug => 'uk-tax-disc',
                              :description => 'The price of a tax disc',
                              :currency_code => 'GBP',
                              :value => 180.0)
  end

  it "should display a form filled with the values of an existing fact" do

    visit "/admin/facts"

    within('table tr', :text => 'Vehicle excise duty') do
      click_on 'Edit'
    end

    current_path.should == "/admin/facts/#{@fact.to_param}/edit"

    within('form') do
      
      page.should have_field 'Name', :with => 'Vehicle excise duty'
      page.should have_field 'Slug', :with => 'uk-tax-disc'
      page.should have_field 'Description', :with => 'The price of a tax disc'
      page.should have_field 'Value', :with => '180.0'
      page.should have_button 'Update Currency fact'

      fill_in 'Name', :with => 'UK vehicle excise duty for 12 months'
      fill_in 'Slug', :with => 'uk-tax-disc-12-months'
      fill_in 'Description', :with => 'The price of a tax disc for a year'
      fill_in 'Value', :with => '190'

      page.should have_select 'Currency code'

      click_on 'Update Currency fact'
    end

    current_path.should == '/admin/facts'

    page.should have_content 'UK vehicle excise duty for 12 months updated'
  end

end
