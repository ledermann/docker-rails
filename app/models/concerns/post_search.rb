module PostSearch
  extend ActiveSupport::Concern

  included do
    searchkick word_start: [ :title, :content, :combined ],
               highlight:  [ :title, :content ],
               suggest:    [ :title, :content ],
               callbacks:  :async
  end

  def content_as_plaintext
    @content_as_plaintext ||= begin
      # Remove styles and get real text, don't just strip tags.
      # Based on https://stackoverflow.com/a/28449868/57950
      doc = Nokogiri::HTML(content)
      doc.xpath('//style').remove
      doc.xpath('//text()').map(&:text).map(&:strip).join(' ')
    end
  end

  def search_data
    {
      title:,
      content:  content_as_plaintext,
      combined: "#{title} #{content_as_plaintext}"
    }
  end

  class_methods do
    def search_for(search_string, options = {})
      search search_string, **{
        fields:       [ :'title^10', :content, :combined ],
        match:        :word_start,
        suggest:      true,
        highlight:    true,
        misspellings: false
      }.merge(options)
    end

    def search_for_autocomplete(search_string, options = {})
      search search_string, **{
        fields:       [ :combined ],
        match:        :word_start,
        limit:        10,
        load:         false,
        highlight:    true,
        misspellings: { prefix_length: 2, below: 3 }
      }.merge(options)
    end

    def autocomplete(search_string)
      search_for_autocomplete(search_string).map do |record|
        record['highlight']['combined.word_start'].map do |fragment|
          fragment.
            scan(/<em>(.*?)<\/em>/).
            join(' ').
            downcase.
            split.
            uniq.
            join(' ')
        end
      end.flatten.uniq
    end
  end
end
