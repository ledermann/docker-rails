FactoryGirl.define do
  factory :clip do
    post { create :post }
    image { fixture_file_upload("spec/fixtures/example.jpg") }
  end
end
