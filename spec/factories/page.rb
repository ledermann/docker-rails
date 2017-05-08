FactoryGirl.define do
  factory :page do
    title 'Foo'
    content 'Lorem ipsum'

    trait :reindex do
      after :create  do |page|
        page.reindex refresh: true
      end
    end
  end
end
