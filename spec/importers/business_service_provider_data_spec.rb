require 'spec_helper'

describe BusinessServiceProviderData do
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/business_service_providers/articles.json" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/business_service_provider/articles.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads trade articles from specified resource' do
      expect(BusinessServiceProvider).to receive(:index) do |articles|
        expect(articles.size).to eq(3)
        3.times { |x| expect(articles[x]).to eq(expected[x]) }
      end
      importer.import
    end
  end
end
