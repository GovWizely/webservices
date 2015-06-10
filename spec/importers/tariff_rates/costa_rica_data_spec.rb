require 'spec_helper'

describe TariffRate::CostaRicaData do
  fixtures_file = "#{Rails.root}/spec/fixtures/tariff_rates/costa_rica/costa_rica.csv"

  s3 = stubbed_s3_client('tariff_rate')
  s3.stub_responses(:get_object, body: open(fixtures_file).read)

  let(:importer) { described_class.new(fixtures_file, s3) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/costa_rica/results.yaml") }

  it_behaves_like 'an importer which indexes the correct documents'
end
