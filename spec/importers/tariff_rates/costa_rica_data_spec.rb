require 'spec_helper'

describe TariffRate::CostaRicaData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/tariff_rates/costa_rica" }
  let(:fixtures_file) { "#{fixtures_dir}/costa_rica.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads COSTA_RICA tariff rates from specified resource' do
      expect(TariffRate::CostaRica).to receive(:index) do |res|
        expect(res).to eq(expected)
      end
      importer.import
    end
  end
end
