# frozen_string_literal: true

class Governator
  class PageScraper
    attr_reader :raw

    def initialize(raw)
      @raw = raw
    end

    def nbsp
      @_nbsp ||= Nokogiri::HTML('&nbsp;').text
    end
  end
end
