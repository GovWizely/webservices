require 'spec_helper'

describe TariffRate::ElSalvadorData do

  fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/el_salvador"
  fixtures_file = "#{fixtures_dir}/el_salvador.csv"

  s3 = stubbed_s3_client('tariff_rate')
  s3.stub_responses(:get_object, body: open(fixtures_file))

  let(:importer) { described_class.new(fixtures_file, s3) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads EL_SALVADOR tariff rates from specified resource' do
      expect(TariffRate::ElSalvador).to receive(:index) do |res|
        expect(res).to eq(expected)
      end
      importer.import
    end
  end
end
