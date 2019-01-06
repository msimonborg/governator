# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

require 'governator/bio_page'
require 'governator/civil_services'
require 'governator/config'
require 'governator/governor'
require 'governator/http_client'
require 'governator/name'
require 'governator/name_parser'
require 'governator/office'
require 'governator/panel'
require 'governator/twitter_client'
require 'governator/version'

# Governator.scrape!
# governors = Governor.governors
class Governator
  BASE_URI = 'https://www.nga.org/'.freeze
  
  class << self
    include HTTPClient

    # Scrapes the NGA website for governor data and returns an array of Governor objects
    def scrape!
      governors.clear
      panels.each { |panel| scrape_governor(panel) }
      governors
    end
    alias governate! scrape!

    # Scrapes data for each thumbnail on the index page, and creates a Governor object
    def scrape_governor(panel)
      tries ||= 0
      governor = Governator::Governor.create(panel)
      puts "Scraped #{governor.official_full} of #{governor.state_name}"

    # Sometimes NGA website returns 504 Gateway errors for an unkown reason.
    # This will raise an exception unless handles. Usually retrying the query
    # will resolve the issue.
    rescue OpenURI::HTTPError => error

      # Raise any HTTPErrors that are not specifically a 504 Gateway Time-out 
      raise error unless error.message == '504 Gateway Time-out'

      # Print error status to the console
      puts "Encountered error: #{error}. Trying again"

      # Allow up to 5 tries before giving up and moving on
      tries += 1
      tries < 5 ? retry : puts("Persistent error, moving on to the next one")
    end

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
      @_index_page ||= Nokogiri::HTML get_page_contents('governors-2')
    end

    def panels
      @_panels ||= index_page.css('.bklyn-team-member').map do |panel|
        Governator::Panel.new(panel)
      end
    end
  end
end
