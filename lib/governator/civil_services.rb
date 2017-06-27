# frozen_string_literal: true

require 'governator/http_client'

class Governator
  class CivilServices
    extend HTTPClient

    def self.json
      @_json ||= JSON.parse get_page_contents(uri)
    end

    def self.uri
      @_uri ||= 'https://raw.githubusercontent.com/CivilServiceUSA/us-governors'\
        '/master/us-governors/data/us-governors.json'
    end

    attr_reader :governor

    def initialize(governor)
      @governor = governor
    end

    def twitter
      record['twitter_handle'] if record
    end

    def facebook
      @_facebook ||= record['facebook_url'].sub('https://www.facebook.com/', '') if facebook_url?
    end

    def facebook_url?
      record && record['facebook_url']
    end

    def photo_url
      record['photo_url'] if record
    end

    def contact_form
      record['contact_page'] if record
    end

    private

    def record
      @_record ||= self.class.json.detect do |record|
        record['last_name'] == governor.last_name && record['state_name'] == governor.state_name
      end
    end
  end
end
