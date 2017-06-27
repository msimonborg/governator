# frozen_string_literal: true

[Governator, Governator::CivilServices, Governator::BioPage, Governator::HTTPClient].each do |klass|
  klass.instance_variable_set(:@base_uri, 'spec/fixtures')
end

Governator::CivilServices.instance_variable_set(:@_uri, '/civil-services.json')

Governator.config { |config| config.use_twitter = false }
