# frozen_string_literal: true

require 'faraday'
require 'nokogiri'
require 'twitter'

require 'governator/bio_page'
require 'governator/civil_services'
require 'governator/name_parser'
require 'governator/panel'
require 'governator/twitter_client'
require 'governator/version'

# Governator.scrape!
# governors = Governor.governors
class Governator
  BASE_URI = 'https://www.nga.org'
  CONN = Faraday.new(url: BASE_URI)

  class << self # <-- Begin class methods
    attr_reader :use_twitter

    def scrape!
      governors.clear
      panels.each do |panel|
        governor = create(panel)
        puts "Scraped #{governor.official_full} of #{governor.state_name}"
      end

      governors
    end

    def governors
      @_governors ||= []
    end

    def to_json
      governors.map(&:to_h)
    end
    alias serialize to_json

    def config
      yield self
    end

    def twitter(&block)
      TwitterClient.config(&block)
    end

    def twitter_client
      TwitterClient.client
    end

    def use_twitter=(boolean)
      raise ArgumentError, 'value must be Boolean value' unless [true, false].include? boolean
      @use_twitter = boolean
    end

    private # private class methods

    def index_page
      @_index_page ||= Nokogiri::HTML(CONN.get('/cms/governors/bios').body)
    end

    def panels
      @_panels ||= index_page.css('.panel.panel-default.governors').map do |panel|
        Panel.new(panel)
      end
    end

    def create(panel)
      new(panel).tap do |g|
        g.send :build
        g.send :save
      end
    end
  end # <-- End class methods

  attr_reader :panel, :state_name, :bio_page, :official_full, :first, :last,
              :middle, :nickname, :suffix, :url, :party, :office_locations,
              :twitter

  def initialize(panel)
    @panel = panel
  end

  def to_h
    {
      photo_url: photo_url,
      state_name: state_name,
      official_full: official_full,
      url: url,
      party: party,
      office_locations: office_locations
    }
  end

  def inspect
    "#<Governator #{official_full}>"
  end

  def secondary_office
    { address: bio_page.alt_address, city: bio_page.alt_city, state: bio_page.alt_state,
      zip: bio_page.alt_zip, phone: bio_page.alt_phone, fax: bio_page.alt_fax,
      office_type: bio_page.alt_office_type }
  end

  def primary_office
    { address: bio_page.address, city: bio_page.city, state: bio_page.state, zip: bio_page.zip,
      phone: bio_page.phone, fax: bio_page.fax, office_type: bio_page.office_type }
  end

  def photo_url
    civil_services.photo_url || BASE_URI + panel.image
  end

  def facebook
    civil_services.facebook
  end

  def contact_form
    civil_services.contact_form
  end

  private

  def build
    @bio_page      = BioPage.new(panel.bio_page)
    @state_name    = panel.state
    @official_full = panel.governor_name
    @url           = bio_page.website
    @party         = bio_page.party

    @first, @last, @middle, @nickname, @suffix = NameParser.new(official_full).parse
    build_office_locations
    fetch_twitter_handle
    self
  end

  def civil_services
    @_civil_services ||= CivilServices.new(self)
  end

  def fetch_twitter_handle
    if self.class.use_twitter == true
      twitter_governor = TwitterClient.governors.detect do |tg|
        tg[:name].match(last) && (
          tg[:location].match(state_name) || tg[:description].match(state_name)
        )
      end

      @twitter = twitter_governor[:screen_name] if twitter_governor
    end

    @twitter = civil_services.twitter if twitter.nil?
  end

  def build_office_locations
    @office_locations = [primary_office]
    @office_locations << secondary_office if bio_page.alt_office_present?
  end

  def save
    self.class.governors << self
    self
  end
end
