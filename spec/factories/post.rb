FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post #{n}" }
    content { '<p>Lorem ipsum</p>' }

    trait :reindex do
      after :create do
        Post.reindex
      end
    end
  end
end
