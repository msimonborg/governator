# frozen_string_literal: true

require 'faraday'
require 'nokogiri'
require 'twitter'

require 'governator/bio_page'
require 'governator/civil_services'
require 'governator/config'
require 'governator/governor'
require 'governator/name'
require 'governator/name_parser'
require 'governator/office'
require 'governator/panel'
require 'governator/twitter_client'
require 'governator/version'

# Governator.scrape!
# governors = Governor.governors
class Governator
  BASE_URI = 'https://www.nga.org'
  CONN = Faraday.new(url: BASE_URI)

  class << self
    def scrape!
      governors.clear
      panels.each do |panel|
        governor = Governator::Governor.create(panel)
        puts "Scraped #{governor.official_full} of #{governor.state_name}"
      end

      governors
    end
    alias governate! scrape!

    def governors
      @_governors ||= []
    end

    def serialize
      governors.map(&:to_h)
    end

    def config
      yield Governator::Config
    end

    def twitter_client
      Governator::TwitterClient.client
    end

    private

    def index_page
      @_index_page ||= Nokogiri::HTML(Governator::CONN.get('/cms/governors/bios').body)
    end

    def panels
      @_panels ||= index_page.css('.panel.panel-default.governors').map do |panel|
        Governator::Panel.new(panel)
      end
    end
  end
end
