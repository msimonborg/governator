# frozen_string_literal: true

class Governator
  # Parses a name into it's component parts
  #
  # === Example
  #   name = "Firstname Two Middlenames 'Nick Name' Lastname, Suffix."
  #   name_parser = NameParser.new(name)
  #   parsed_name = name_parser.parse
  #   parsed_name.first_name # => "Firstname"
  #   parsed_name.middle_name # => "Two Middlenames"
  #   parsed_name.nickname # => "Nick Name"
  #   parsed_name.last_name # => "Lastname"
  #   parsed_name.suffix # => "Suffix"
  class NameParser
    # Initialize a new NameParser object
    #
    # @param original [String] the original name to parse
    def initialize(original)
      @original = original
    end

    # Parse the name into its component parts
    #
    # @api public
    #
    # @return [Governator::Name]
    def parse
      split_name
      Governator::Name.new(original, first, middle, nickname, last, suffix)
    end

    private

    attr_reader :original, :first, :last, :middle, :nickname, :suffix

    # @api private
    def first_middle_last
      @_first_middle_last ||= parsing_copy.split(' ')
    end

    # @api private
    def split_name
      detect_nickname
      detect_suffix
      if two_part_name?
        set_first_and_last
      elsif initialed_first_name?
        set_name_with_initialed_first
      elsif three_or_more_part_name?
        set_first_last_and_middle
      end
    end

    # @api private
    def three_or_more_part_name?
      first_middle_last.length >= 3
    end

    # @api private
    def initialed_first_name?
      first_middle_last[0].include?('.') && first_middle_last[1].include?('.')
    end

    # @api private
    def two_part_name?
      first_middle_last.length == 2
    end

    # @api private
    def set_first_and_last
      @first = first_middle_last.first
      @last  = first_middle_last.last
    end

    # @api private
    def set_name_with_initialed_first
      @first  = "#{first_middle_last.first} #{first_middle_last[1]}"
      @last   = first_middle_last.last
      @middle = first_middle_last[2..-2].join(' ')
    end

    # @api private
    def set_first_last_and_middle
      @first  = first_middle_last.first
      @last   = first_middle_last.last
      @middle = first_middle_last[1..-2].join(' ')
    end

    # @api private
    def detect_nickname
      match_data = parsing_copy.match(/\s["'][\w\s]+["']/)
      return unless match_data
      @nickname = match_data.to_s if match_data
      parsing_copy.sub!(nickname, '')
      nickname.sub!(' ', '')
    end

    # @api private
    def detect_suffix
      match_data = parsing_copy.match(/,\s\w+\.?/)
      return unless match_data
      @suffix = match_data.to_s if match_data
      parsing_copy.sub!(suffix, '')
      suffix.delete!(', ')
    end

    # @api private
    def parsing_copy
      @_parsing_copy ||= original.dup
    end
  end
end
