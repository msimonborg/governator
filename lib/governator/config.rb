# frozen_string_literal: true

class Governator
  # The configuration object to set Twitter preferences and keys
  class Config
    class << self
      attr_reader :use_twitter

      def use_twitter=(boolean)
        raise ArgumentError, 'value must be Boolean value' unless [true, false].include? boolean
        @use_twitter = boolean
      end

      def use_twitter?
        @use_twitter
      end

      def twitter(&block)
        Governator::TwitterClient.config(&block)
      end
    end
  end
end
