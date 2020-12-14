# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Create admin user..."
User.find_or_create_by(is_admin: true) do |user|
  user.email    = ENV.fetch('APP_ADMIN_EMAIL')
  user.password = ENV.fetch('APP_ADMIN_PASSWORD')
end
User.first.confirm!

Post.reindex

puts "Add articles about programming languages from Wikipedia..."
WikipediaJob.perform_now
