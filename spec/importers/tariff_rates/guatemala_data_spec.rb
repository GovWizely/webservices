require 'spec_helper'

describe TariffRate::GuatemalaData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/tariff_rates/guatemala" }
  let(:fixtures_file) { "#{fixtures_dir}/guatemala.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads GUATEMALA tariff rates from specified resource' do
      expect(TariffRate::Guatemala).to receive(:index) do |res|
        expect(res).to eq(expected)
      end
      importer.import
    end
  end
end
