# frozen_string_literal: true

class Governator
  # Instance methods included in the Governator class
  class Governor
    attr_reader :panel, :state_name, :official_full, :parsed_name,
                :url, :party, :office_locations, :twitter

    private :panel

    def self.create(panel)
      new(panel).tap do |g|
        g.send :build
        g.send :save
      end
    end

    # Initializes a new Governator instance
    #
    # @param panel [Governator::Panel] the Panel scraper object to pull the Governor's data from
    def initialize(panel)
      @panel = panel
    end

    def to_h
      syms = %i[photo_url state_name official_full url party office_locations]
      syms.each_with_object({}) do |sym, hsh|
        hsh[sym] = send(sym)
      end
    end

    def inspect
      "#<Governator #{official_full}>"
    end

    def secondary_office
      @_secondary_office ||= office(prefix: :alt_)
    end

    def primary_office
      @_primary_office ||= office
    end

    def photo_url
      civil_services.photo_url || panel.image
    end

    def facebook
      civil_services.facebook
    end

    def contact_form
      civil_services.contact_form
    end

    def first_name
      parsed_name.first_name
    end

    def middle_name
      parsed_name.middle_name
    end

    def nickname
      parsed_name.nickname
    end

    def last_name
      parsed_name.last_name
    end

    def suffix
      parsed_name.suffix
    end

    private

    def office(prefix: nil)
      syms = %i[address city state zip phone fax office_type]
      syms.each_with_object(Governator::Office.new) do |sym, office|
        office[sym] = bio_page.send("#{prefix}#{sym}")
      end
    end

    def build
      @state_name    = panel.state
      @official_full = panel.governor_name
      @url           = bio_page.website
      @party         = bio_page.party

      @parsed_name = Governator::NameParser.new(official_full).parse
      build_office_locations
      fetch_twitter_handle
      self
    end

    def bio_page
      @_bio_page ||= Governator::BioPage.new(panel.bio_page)
    end

    def civil_services
      @_civil_services ||= Governator::CivilServices.new(self)
    end

    def fetch_twitter_handle
      check_twitter_client_for_handle if Governator::Config.use_twitter?
      @twitter = civil_services.twitter if twitter.nil?
    end

    def check_twitter_client_for_handle
      twitter_governor = Governator::TwitterClient.governors.detect do |tg|
        tg[:name].match(last_name) && (
          tg[:location].match(state_name) || tg[:description].match(state_name)
        )
      end

      @twitter = twitter_governor[:screen_name] if twitter_governor
    end

    def build_office_locations
      @office_locations = [primary_office]
      @office_locations << secondary_office if bio_page.alt_office_present?
    end

    def save
      Governator.governors << self
      self
    end
  end
end
