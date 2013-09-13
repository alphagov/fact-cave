# encoding: UTF-8
require 'spec_helper'

feature "attempting to create a fact as a non-editorial user" do
  it "should redirect to the facts index and display an explanatory message" do
    login_as_stub_user
    visit "/admin/facts/new"
    page.should have_content "You are not authorized to access this page."
    current_path.should == "/admin/facts"
  end
end

feature "creating a fact" do

  before :each do
    login_as_stub_editor
  end

  it "should display validation errors if the fact couldn't be saved" do

    visit "/admin/facts/new"
    
    within('form') do
      page.should have_field 'Name'
      click_on 'Create Fact'
    end

    within('div.error', :text => 'Name') do
      page.should have_content "can't be blank"
    end
    within('div.error', :text => 'Slug') do
      page.should have_content "can't be blank"
    end
    within('div.error', :text => 'Value') do
      page.should have_content "can't be blank"
    end
    page.should have_content 'Could not save fact'
  end
  
  it "should display a form with fields and controls to submit a new fact" do

    visit "/admin/facts/new"

    within('form') do
      
      page.should have_field 'Name'
      page.should have_field 'Slug'
      page.should have_field 'Description'
      page.should have_field 'Value'
      
      page.should have_button 'Create Fact'

      fill_in 'Name', :with => 'Factoid'
      fill_in 'Slug', :with => 'factoid'
      fill_in 'Description', :with => 'This is a factoid'
      fill_in 'Value', :with => 'Factoids are small truths which float around a larger fact'
      click_on 'Create Fact'
    end

    current_path.should == '/admin/facts'

    page.should have_content 'Factoid'
    page.should have_content 'Factoid saved'
  end

  describe "creating a currency fact" do
    it "should present currency specific formatting fields" do
      visit "/admin/facts/new?data_type=currency_fact"

      page.should have_field 'Name'
      page.should have_field 'Slug'
      page.should have_field 'Description'
      page.should have_field 'Value'
      page.should have_select 'Currency code'
      page.should have_css "#currency_fact_currency_code option[value='GBP'][selected='selected']"

      fill_in 'Name', :with => 'Vehicle excise duty'
      fill_in 'Slug', :with => 'uk-tax-disc'
      fill_in 'Value', :with => '180.0'
      click_on 'Create Currency fact'

      within('table tr', :text => 'Vehicle excise duty') do
        page.should have_content 'uk-tax-disc'
        page.should have_content 'Currency'
        page.should have_content '£180.00'
      end
      page.should have_content 'Vehicle excise duty saved'
      
    end
  end

  describe "creating a date fact" do
    it "should present a form" do
      visit "/admin/facts/new?data_type=date_fact"

      page.should have_field 'Name'
      page.should have_field 'Slug'
      page.should have_field 'Description'
      page.should have_field 'Value'

      fill_in 'Name', :with => 'Battle of Hastings'
      fill_in 'Slug', :with => 'battle-of-hastings'
      fill_in 'Value', :with => '14 Oct 1066'
      click_on 'Create Date fact'

      within('table tr', :text => 'Battle of Hastings') do
        page.should have_content 'battle-of-hastings'
        page.should have_content 'Date'
        page.should have_content '1066-10-14'
      end
      page.should have_content 'Battle of Hastings saved'
    end
  end

  describe "creating a numeric fact" do
    it "should present numeric specific formatting fields" do
      visit "/admin/facts/new?data_type=numeric_fact"

      page.should have_field 'Name'
      page.should have_field 'Slug'
      page.should have_field 'Description'
      page.should have_field 'Value'
      page.should have_field 'Unit'

      fill_in 'Name', :with => 'VAT rate'
      fill_in 'Slug', :with => 'vat-rate'
      fill_in 'Value', :with => '20'
      fill_in 'Unit', :with => '%'
      click_on 'Create Numeric fact'

      within('table tr', :text => 'VAT rate') do
        page.should have_content 'vat-rate'
        page.should have_content 'Numeric'
        page.should have_content '20%'
      end
      page.should have_content 'VAT rate saved'
    end
  end
end
