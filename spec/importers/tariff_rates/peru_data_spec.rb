require 'spec_helper'

describe TariffRate::PeruData do
  fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/peru"
  fixtures_file = "#{fixtures_dir}/peru.csv"

  s3 = stubbed_s3_client('tariff_rate')
  s3.stub_responses(:get_object, body: open(fixtures_file))

  let(:importer) { described_class.new(fixtures_file, s3) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads PERU tariff rates from specified resource' do
      expect(TariffRate::Peru).to receive(:index) do |res|
        expect(res).to eq(expected)
      end
      importer.import
    end
  end
end
