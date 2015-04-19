require 'spec_helper'

describe ParatureFaqData do
  before { ParatureFaq.recreate_index }
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/parature_faqs/" }
  let(:resource) { "#{fixtures_dir}/articles/article%d.xml" }
  let(:folders_resource) { "#{fixtures_dir}/folders.xml" }
  let(:importer) { ParatureFaqData.new(resource, folders_resource) }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    let(:entry_hash) { YAML.load_file("#{File.dirname(__FILE__)}/parature_faq/results.yaml") }

    it 'loads parature faqs from specified resource' do
      expect(ParatureFaq).to receive(:index) do |entries|
        expect(entries.size).to eq(29)
        expect(entries).to match_array entry_hash
      end
      importer.import
    end

    context 'when an unexpected error is encountered' do
      before do
        allow(importer).to receive(:extract_hash_from_resource) do
          fail OpenURI::HTTPError.new('503 Service Unavailable', nil)
        end
      end

      it 'raises the error' do
        expect { importer.import }
          .to raise_error(OpenURI::HTTPError, '503 Service Unavailable')
      end
    end

    context 'when an expected error is encountered' do
      before do
        allow(importer).to receive(:extract_hash_from_resource) do
          fail OpenURI::HTTPError.new('404 Not Found', nil)
        end
      end

      it 'does not raise an error' do
        expect { importer.import }.not_to raise_error
      end
    end
  end
end
