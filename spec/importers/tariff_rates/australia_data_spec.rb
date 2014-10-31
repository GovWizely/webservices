require 'spec_helper'

describe TariffRate::AustraliaData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/tariff_rates/australia" }
  let(:fixtures_file) { "#{fixtures_dir}/australia.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads AUSTRALIA tariff rates from specified resource' do
      expect(TariffRate::Australia).to receive(:index) do |res|
        expect(res).to eq(expected)
      end
      importer.import
    end
  end
end
