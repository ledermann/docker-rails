FactoryGirl.define do
  factory :page do
    sequence(:title) { |n| "Page #{n}" }
    content 'Lorem ipsum'

    trait :reindex do
      after :create  do |page|
        page.reindex refresh: true
      end
    end
  end
end
