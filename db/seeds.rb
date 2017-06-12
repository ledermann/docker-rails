# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require_relative 'wikipedia'

# Add some articles from Wikipedia
Searchkick.callbacks(false) do
  Wikipedia::List.new.articles.each do |article|
    next unless article.valid?
    puts article.title

    Post.find_or_initialize_by(title: article.title) do |p|
      p.content = article.extract
    end.save!
  end
end
Post.reindex

# Create Admin user
User.find_or_create_by(is_admin: true) do |user|
  user.email    = ENV.fetch('APP_ADMIN_EMAIL')
  user.password = ENV.fetch('APP_ADMIN_PASSWORD')
end
