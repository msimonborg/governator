# frozen_string_literal: true

require 'fixtures_setup_helper'

describe 'Governator' do
  it '.index_page gets the bios page' do
    expect(Governator.send(:index_page)).to be_a Nokogiri::HTML::Document
  end

  it '.panels parses the bios page and initializes a Governator::Panel object for each governor' do
    panels = Governator.send :panels

    expect(panels).to be_a Array
    expect(panels.count).to be 55
    expect(panels.all? { |panel| panel.is_a? Governator::Panel }).to be true
  end

  it 'scrapes the governors' do
    Governator.scrape!
    governors = Governator.governors

    expect(governors).to be_a Array
    expect(governors.count).to be 55
    expect(governors.all? { |governor| governor.is_a?(Governator::Governor) }).to be true
  end
end
