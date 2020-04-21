# frozen_string_literal: true

FactoryBot.define do
  sequence :user_name do |n|
    "User #{n}"
  end

  factory :user do
    name { generate(:user_name) }

    trait :with_city do
      city { create(:city) }
    end

    trait :extra do
      name { 'Extra User' }

      trait :with_city do
        city { create(:city, :extra) }
      end
    end
  end
end
