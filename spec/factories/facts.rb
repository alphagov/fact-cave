# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fact do
    sequence(:slug) {|n| "fact-#{n}" }
    name            "Test Fact"
    value           "42"
  end
end
