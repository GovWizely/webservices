require 'spec_helper'

describe ParatureFaqData, vcr: { cassette_name: 'importers/parature_faq.yml', record: :once } do
  before { ParatureFaq.recreate_index }
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/parature_faqs/" }
  let(:resource) { "#{fixtures_dir}/articles/article%d.xml" }
  let(:folders_resource) { "#{fixtures_dir}/folders.xml" }
  let(:importer) { ParatureFaqData.new(resource, folders_resource) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/parature_faq/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which indexes the correct documents'

  describe '#import' do
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
