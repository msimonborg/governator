# frozen_string_literal: true

require 'governator/page_scraper'

class Governator
  class Panel < PageScraper
    def image
      @_image ||= raw.css('.bklyn-team-member-avatar img').first['src']
    end

    def bio_page
      @_bio_page ||= raw.css('a').first['href']
    end

    def governor_name
      @_governor_name ||= raw.css('a .bklyn-team-member-description')
                             .first
                             .text
                             .sub('Governor ', '')
                             .gsub('  ', ' ')
    end

    def state
      state = raw.css('a .bklyn-team-member-name').first.text
      case state
      when 'Northern Mariana Islands' then 'Commonwealth of the ' + state
      when 'Virgin Islands' then 'United States ' + state
      else state
      end
    end
  end
end
