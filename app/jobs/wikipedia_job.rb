require 'wikipedia'

class WikipediaJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PaperTrail.whodunnit = 'Wikipedia'
    Searchkick.callbacks(:bulk) do
      count = 0
      Wikipedia::List.new.articles.each do |article|
        next unless article.valid?
        logger.debug "Processing '#{article.title}'"

        short_title = article.title.remove(' (programming language)')
        post = Post.find_or_initialize_by(title: short_title)
        post.content = article.extract
        post.copyright = <<-HTML
          <p>This article is based on the article <a rel="nofollow" href="#{article.html_url}">#{article.title}</a> from the free encyclopedia <a rel="nofollow" href="https://en.wikipedia.org/wiki/Main_Page">Wikipedia</a> and is licened under <a rel="nofollow" href="http://www.gnu.org/licenses/fdl-1.3.txt">GNU Free Documentation License</a> and <a rel="nofollow" href="https://creativecommons.org/licenses/by-sa/3.0/">Creative Commons CC-BY-SA 3.0 Unported</a> (<a rel="nofollow" href="https://creativecommons.org/licenses/by-sa/3.0/legalcode">Summary</a>). In Wikipedia there is a <a rel="nofollow" href="#{article.history_url}">List of authors</a> available.</p>
        HTML
        post.copyright.strip!

        if post.changed?
          logger.info "Updating post '#{post.title}'"
          post.save!
          count += 1
        end
      end

      logger.info "Updated #{count} posts"
    end
  end
end
