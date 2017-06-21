# frozen_string_literal: true

class Governator
  class TwitterClient
    def self.client(&block)
      @_client ||= Twitter::REST::Client.new(&block)
    end

    def self.governors
      @_governors ||= nga_list_members + rga_list_members + cspan_list_members
    end

    def self.nga_list
      @_nga_list ||= client.lists('NatlGovsAssoc').detect { |l| l.name == 'Governors' }
    end

    def self.nga_list_members
      @_nga_list_members ||= client.list_members(nga_list, count: 100).attrs[:users]
    end

    def self.rga_list
      @_rga_list ||= client.lists('The_RGA').detect {|l| l.name == 'GOP Governors' }
    end

    def self.rga_list_members
      @_rga_list_members ||= client.list_members(rga_list, count: 100).attrs[:users]
    end

    def self.cspan_list
      @_cspan_list ||= client.lists('cspan').detect {|l| l.name == 'Governors' }
    end

    def self.cspan_list_members
      @_cspan_list_members ||= client.list_members(cspan_list, count: 100).attrs[:users]
    end
  end
end
