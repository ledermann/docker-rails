FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post #{n}" }
    content '<p>Lorem ipsum</p>'

    trait :reindex do
      after :create  do |post|
        post.reindex refresh: true
      end
    end
  end
end
