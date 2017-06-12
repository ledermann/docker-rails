require 'open-uri'

module Wikipedia
  class List
    def articles
      result = []

      loop do
        result += names.map { |name| Article.new(name) }
        break unless @page = next_page
      end

      result
    end

    private

    def names
      as_json['query']['pages'].to_a.first.second['links'].map do |hash|
        hash['title']
      end
    end

    def next_page
      as_json['continue']['plcontinue'] if as_json['continue']
    end

    def as_json
      @as_json ||= Hash.new do |h, key|
        h[key] = JSON.load(open(url))
      end
      @as_json[@page]
    end

    def url
      result = "https://en.wikipedia.org/w/api.php?format=json&action=query&titles=List_of_programming_languages&prop=links&pllimit=500"
      result << "&plcontinue=#{@page}" if @page.present?
      result
    end
  end

  class Article
    def initialize(name)
      @name = name
    end

    def url
      escaped_name = CGI::escape(@name)
      "https://en.wikipedia.org/w/api.php?format=json&action=query&titles=#{escaped_name}&prop=extracts&exintro=&redirects"
    end

    def title
      raw_title.remove(' (programming language)')
    end

    def extract
      Kramdown::Document.new(raw_extract, :html_to_native => true).to_kramdown
    end

    def valid?
      raw_extract.present? && not(
        title == 'Wikipedia:Wikimedia sister projects' ||
        title =~ /lists? of/i
      )
    end

    private

    def raw_title
      @raw_title ||= as_json['query']['pages'].to_a.first.second['title']
    end

    def raw_extract
      @raw_extract ||= as_json['query']['pages'].to_a.first.second['extract']
    end

    def as_json
      @as_json ||= JSON.load(open(url))
    end
  end
end
