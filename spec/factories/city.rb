# frozen_string_literal: true

FactoryBot.define do
  sequence :city_name do |n|
    "City #{n}"
  end

  factory :city do
    name { generate(:city_name) }

    trait :extra do
      name { 'Extra City' }
    end
  end
end
