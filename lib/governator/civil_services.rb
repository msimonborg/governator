# frozen_string_literal: true

class Governator
  class CivilServices
    def self.json
      @_json ||= JSON.parse Faraday.get(
        'https://raw.githubusercontent.com/CivilServiceUSA/us-governors'\
          '/master/us-governors/data/us-governors.json'
      ).body
    end

    attr_reader :governor

    def initialize(governor)
      @governor = governor
    end

    def twitter
      record['twitter_handle'] if record
    end

    def facebook
      if record && record['facebook_url']
        @_facebook ||= record['facebook_url'].sub('https://www.facebook.com/', '')
      end
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
        record['last_name'] == governor.last && record['state_name'] == governor.state_name
      end
    end
  end
end
