# encoding: UTF-8
require 'spec_helper'

feature "listing facts to a non-editorial user" do

  before :each do
    login_as_stub_user
    
      FactoryGirl.create(:fact, :slug => "fact-1", 
                         :name => "Fact 1", :value => "value-1")
      FactoryGirl.create(:numeric_fact, :slug => "vat-rate",
                        :name => "VAT rate", :value => 20.0,
                        :unit => "%")
      FactoryGirl.create(:date_fact, :slug => "battle-of-hastings",
                        :name => "Battle of Hastings", :value => Date.parse('14 Oct 1066'))
      FactoryGirl.create(:currency_fact, :slug => "uk-tax-disc", :name => "UK tax disc",
                         :value => 190.0, :currency_code => 'GBP')
  end

  it "should display a table of existing facts" do

    visit "/admin/facts"

    within('table tr', :text => 'Fact 1') do
      page.should have_content 'fact-1'
      page.should have_content 'Text'
      page.should have_content 'value-1'
      page.should have_no_link 'Edit'
      page.should have_no_button 'Delete'
    end
    within('table tr', :text => 'VAT rate') do
      page.should have_content 'vat-rate'
      page.should have_content 'Numeric'
      page.should have_content '20.0'
      page.should have_content '20%'
      page.should have_no_link 'Edit'
      page.should have_no_button 'Delete'
    end
    within('table tr', :text => 'Battle of Hastings') do
      page.should have_content 'battle-of-hastings'
      page.should have_content 'Date'
      page.should have_content '1066-10-14'
    end
    within('table tr', :text => 'UK tax disc') do
      page.should have_content 'uk-tax-disc'
      page.should have_content 'Currency'
      page.should have_content '190.0'
      page.should have_content '£190.00'
    end

    page.should have_no_link 'New Currency Fact'
    page.should have_no_link 'New Date Fact'
    page.should have_no_link 'New Numeric Fact'
    page.should have_no_link 'New Text Fact'
    
  end

end

feature "navigating to new fact form" do
  it "should permit editors" do  

    FactoryGirl.create(:fact, :name => 'Change me!')
    login_as_stub_editor
    
    visit '/admin/facts'

    within('table tr', :text => 'Change me!') do
      page.should have_link('Edit')
      page.should have_button('Delete')
    end

    click_on 'New Text Fact'

    current_path.should == '/admin/facts/new'
  end
end
