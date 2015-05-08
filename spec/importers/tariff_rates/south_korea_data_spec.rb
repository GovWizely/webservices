require 'spec_helper'

describe TariffRate::SouthKoreaData do
  fixtures_file = "#{Rails.root}/spec/fixtures/tariff_rates/south_korea/korea.csv"

  s3 = stubbed_s3_client('tariff_rate')
  s3.stub_responses(:get_object, body: open(fixtures_file).read)

  let(:importer) { described_class.new(fixtures_file, s3) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/south_korea/results.yaml") }

  describe '#import' do
    it 'loads SOUTH_KOREA tariff rates from specified resource' do
      expect(TariffRate::SouthKorea).to receive(:index) do |res|
        expect(res).to eq(expected)
      end
      importer.import
    end
  end
end
