# frozen_string_literal: true

class Governator
  # Wrapper for the Twitter client with convenience methods
  class TwitterClient
    class << self
      attr_reader :client

      def config(&block)
        @client = Twitter::REST::Client.new(&block)
      end

      def governors
        @_governors ||= nga_list_members + rga_list_members + cspan_list_members + dga_list_members
      end

      def nga_list
        @_nga_list ||= client.lists('NatlGovsAssoc').detect { |l| l.name == 'Governors' }
      end

      def nga_list_members
        @_nga_list_members ||= client.list_members(nga_list, count: 100).attrs[:users]
      end

      def rga_list
        @_rga_list ||= client.lists('The_RGA').detect { |l| l.name == 'GOP Governors' }
      end

      def rga_list_members
        @_rga_list_members ||= client.list_members(rga_list, count: 100).attrs[:users]
      end

      def dga_list
        @_dga_list ||= client.lists('DemGovs').detect { |l| l.name == 'Democratic Governors' }
      end

      def dga_list_members
        @_dga_list_members ||= client.list_members(dga_list, count: 100).attrs[:users]
      end

      def cspan_list
        @_cspan_list ||= client.lists('cspan').detect { |l| l.name == 'Governors' }
      end

      def cspan_list_members
        @_cspan_list_members ||= client.list_members(cspan_list, count: 100).attrs[:users]
      end
    end
  end
end
