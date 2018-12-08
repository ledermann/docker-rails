FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Post #{n}" }
    content { '<p>Lorem ipsum</p>' }

    trait :reindex do
      after :create do |post|
        post.reindex
        Post.search_index.refresh
      end
    end
  end
end
