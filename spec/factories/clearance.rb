FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password "password"
    is_admin false

    factory :admin do
      is_admin true
    end
  end
end
