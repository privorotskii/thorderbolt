# frozen_string_literal: true

FactoryBot.define do
  sequence :post_name do |n|
    "Post #{n}"
  end

  factory :post do
    name { generate(:post_name) }

    trait :with_user do
      user { create(:user, :with_city) }
    end

    trait :extra do
      name { 'Extra Post' }

      user { create(:user, :extra, :with_city) }
    end
  end
end
