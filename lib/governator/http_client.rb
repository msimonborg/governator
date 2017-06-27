# frozen_string_literal: true

require 'open-uri'

class Governator
  # Module to mixin HTTP web content retrieval
  module HTTPClient
    module_function

    def get_page_contents(path)
      path = URI.parse(path)
      uri  = path.relative? ? "#{base_uri}#{path}" : path
      open(uri, &:read)
    end

    def base_uri
      @base_uri ||= 'https://www.nga.org'
    end
  end
end
