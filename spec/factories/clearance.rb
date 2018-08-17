FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password { "password" }
    is_admin { false }
    email_confirmed_at { Time.current }

    factory :admin do
      is_admin { true }
    end

    trait :unconfirmed do
      email_confirmed_at { nil }
      email_confirmation_token { Clearance::Token.new }
    end
  end
end
