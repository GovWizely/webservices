require 'spec_helper'

describe TariffRate::ElSalvadorData do

  fixtures_file = "#{Rails.root}/spec/fixtures/tariff_rates/el_salvador/el_salvador.csv"

  s3 = stubbed_s3_client('tariff_rate')
  s3.stub_responses(:get_object, body: open(fixtures_file))

  let(:importer) { described_class.new(fixtures_file, s3) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/el_salvador/results.yaml") }

  describe '#import' do
    it 'loads EL_SALVADOR tariff rates from specified resource' do
      expect(TariffRate::ElSalvador).to receive(:index) do |res|
        expect(res).to eq(expected)
      end
      importer.import
    end
  end
end
