FactoryBot.define do
  factory :clip do
    post { create :post }
    image { fixture_file_upload("spec/fixtures/example.jpg") }
  end

  factory :clip_unprocessed, class: Clip do
    post { create :post }

    image_data do
      {
        id: "123456789012345678901234567890",
        storage: "cache",
        metadata: {
          size: 123_456,
          filename: "foo-bar.jpg",
          mime_type: "image/jpeg"
        }
      }
    end
  end
end
