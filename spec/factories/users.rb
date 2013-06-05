# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "winston-#{n}@gov.uk" }
    name "Stub User"
    permissions { ["signin"] }
  end
end
