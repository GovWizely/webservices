require 'spec_helper'

describe TariffRate::SouthKoreaData do

  fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/south_korea"
  fixtures_file = "#{fixtures_dir}/korea.csv"

  s3 = Aws::S3::Client.new(stub_responses: true, access_key_id: ENV['AWS_ACCESS_KEY_ID_TARIFFS'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY_TARIFFS'])
  s3.stub_responses(:get_object, body: open(fixtures_file))

  let(:importer) { described_class.new(fixtures_file, s3) }
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
