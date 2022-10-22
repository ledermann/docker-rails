require 'net/http'

module Wikipedia
  class List
    def articles
      result = []

      loop do
        result += names.map { |name| Article.new(name) }
        @page = next_page
        break unless @page
      end

      result
    end

    private

    def names
      as_json['query']['pages'].to_a.first.second['links'].pluck('title')
    end

    def next_page
      as_json['continue']['plcontinue'] if as_json['continue']
    end

    def as_json
      @as_json ||= Hash.new do |h, key|
        h[key] = JSON.parse(Net::HTTP.get(URI(url)))
      end
      @as_json[@page]
    end

    def url
      result = "https://en.wikipedia.org/w/api.php?format=json&action=query&titles=List_of_programming_languages&prop=links&pllimit=500"
      result << "&plcontinue=#{CGI.escape @page}" if @page.present?
      result
    end
  end

  class Article
    def initialize(query)
      @query = query
    end

    def json_url
      escaped_query = CGI.escape(@query)
      "https://en.wikipedia.org/w/api.php?format=json&action=query&titles=#{escaped_query}&prop=extracts&exintro=&redirects"
    end

    def html_url
      escaped_title = title.tr(' ', '_')
      "https://en.wikipedia.org/wiki/#{escaped_title}"
    end

    def history_url
      escaped_title = title.tr(' ', '_')
      "https://en.wikipedia.org/w/index.php?title=#{escaped_title}&amp;action=history"
    end

    def valid?
      extract.present? &&
        title != 'Wikipedia:Wikimedia sister projects' &&
        title !~ /lists? of/i
    end

    def title
      @title ||= as_json['query']['pages'].to_a.first.second['title']
    end

    def extract
      raw_extract.
        to_s.
        delete("\n").
        gsub('<p></p>', '').
        gsub('<i>', '<em>').
        gsub('</i>', '</em>').
        gsub('<b>', '<strong>').
        gsub('</b>', '</strong>')
    end

    private

    def raw_extract
      @raw_extract ||= as_json['query']['pages'].to_a.first.second['extract']
    end

    def as_json
      @as_json ||= JSON.parse(Net::HTTP.get(URI(json_url)))
    end
  end
end
