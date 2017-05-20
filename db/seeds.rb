# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

class Generator
  def attributes
    {
      title:   title,
      content: content
    }
  end

  private

  def faker
    @faker ||= [
      Faker::Hipster,
      Faker::Lorem
    ].sample
  end

  def title
    faker.words(3, true).join(' ').upcase_first
  end

  def content
    (1..3).map { faker.paragraph(5, true, 10) }.join("\n\n")
  end
end

# Create some random posts
Searchkick.callbacks(false) do
  100.times { Post.create!(Generator.new.attributes) }
end
Post.reindex

# Create Admin user
User.find_or_create_by(is_admin: true) do |user|
  user.email    = ENV.fetch('APP_ADMIN_EMAIL')
  user.password = ENV.fetch('APP_ADMIN_PASSWORD')
end
