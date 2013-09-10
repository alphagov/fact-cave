# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fact do
    sequence(:slug) {|n| "fact-#{n}" }
    name            "Test Fact"
    value           "Dogs can't look up"

    factory :currency_fact, :class => "CurrencyFact" do
      currency_code   "GBP"
      value BigDecimal.new("1000.00")
    end

    factory :date_fact, :class => "DateFact" do
      value Date.parse('1 Jan 2013')
    end

    factory :numeric_fact, :class => "NumericFact" do
      unit "%"
      value 99.9
    end
  end
end
