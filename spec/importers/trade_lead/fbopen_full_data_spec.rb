require 'spec_helper'

describe TradeLead::FbopenImporter::FullData do
  let(:resource) { "#{Rails.root}/spec/fixtures/trade_leads/fbopen/full_source_input.xml" }
  let(:importer)     { described_class.new(resource) }
  let(:expected_results) { YAML.load_file("#{File.dirname(__FILE__)}/fbopen/full_source_results.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    before do
      allow(Date).to receive(:today).and_return(Date.parse('2015-01-01'))
    end
    it 'loads leads from full xml' do
      expect(TradeLead::Fbopen).to receive(:index) do |fbo|
        expect(fbo.size).to eq(4)
        expect(fbo).to match(expected_results)
      end
      importer.import
    end
  end

  describe '#model_class' do
    it 'returns correct model_class' do
      expect(importer.model_class).to match(TradeLead::Fbopen)
    end
  end

end
