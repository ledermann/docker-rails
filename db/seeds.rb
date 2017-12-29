# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require_relative 'wikipedia'

# Add some articles from Wikipedia
PaperTrail.whodunnit = 'Wikipedia'
Searchkick.callbacks(:bulk) do
  Wikipedia::List.new.articles.each do |article|
    next unless article.valid?
    short_title = article.title.remove(' (programming language)')
    puts short_title

    post = Post.find_or_initialize_by(title: short_title)
    post.content = article.extract
    post.copyright = <<-HTML
      <p>This article is based on the article <a rel="nofollow" href="#{article.html_url}">#{article.title}</a> from the free encyclopedia <a rel="nofollow" href="https://en.wikipedia.org/wiki/Main_Page">Wikipedia</a> and is licened under <a rel="nofollow" href="http://www.gnu.org/licenses/fdl-1.3.txt">GNU Free Documentation License</a> and <a rel="nofollow" href="https://creativecommons.org/licenses/by-sa/3.0/">Creative Commons CC-BY-SA 3.0 Unported</a> (<a rel="nofollow" href="https://creativecommons.org/licenses/by-sa/3.0/legalcode">Summary</a>). In Wikipedia there is a <a rel="nofollow" href="#{article.history_url}">List of authors</a> available.</p>
    HTML
    post.copyright.strip!

    post.save! if post.changed?
  end
end

# Create Admin user
User.find_or_create_by(is_admin: true) do |user|
  user.email    = ENV.fetch('APP_ADMIN_EMAIL')
  user.password = ENV.fetch('APP_ADMIN_PASSWORD')
end
User.first.confirm!
