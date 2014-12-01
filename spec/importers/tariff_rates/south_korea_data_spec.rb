require 'spec_helper'

describe TariffRate::SouthKoreaData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/tariff_rates/south_korea" }
  let(:fixtures_file) { "#{fixtures_dir}/korea.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads SOUTH_KOREA tariff rates from specified resource' do
      expect(TariffRate::SouthKorea).to receive(:index) do |res|
        expect(res).to eq(expected)
      end
      importer.import
    end
  end
end
