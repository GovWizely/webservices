require 'spec_helper'

describe TradeLead::FbopenImporter::FullData, vcr: { cassette_name: 'importers/trade_leads/fbopen/full_source_input.yml', record: :once } do
  let(:resource)     { "#{Rails.root}/spec/fixtures/trade_leads/fbopen/full_source_input.xml" }
  let(:importer)     { described_class.new(resource) }
  let(:expected)     { YAML.load_file("#{File.dirname(__FILE__)}/fbopen/full_source_results.yaml") }
  before { allow(Date).to receive(:today).and_return(Date.parse('2015-01-01')) }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which indexes the correct documents'

  describe '#model_class' do
    it 'returns correct model_class' do
      expect(importer.model_class).to match(TradeLead::Fbopen)
    end
  end
end
