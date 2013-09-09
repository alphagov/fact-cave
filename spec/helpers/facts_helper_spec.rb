require 'spec_helper'

include FactsHelper
include ActionView::Helpers::FormOptionsHelper

describe FactsHelper do
  describe "currency_format_options" do
    it "should produce optgroups of currency names and codes" do
      options = currency_format_options('GBP')
      options.should =~ /^<optgroup label="Common">/
      options.should =~ /<option value="GBP" selected="selected">Pound Sterling/
      options.should =~ /<optgroup label="All"/
    end
  end

  describe "numeric_format_options" do
    it "should make an options array of common numeric formats" do
      options = numeric_format_options
      options.should eq([["None"], ["Percentage", "percentage"]])
    end
  end
end
