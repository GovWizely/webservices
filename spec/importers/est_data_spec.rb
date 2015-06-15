require 'spec_helper'

describe EstData do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/est" }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/est_articles/est_articles.json" }
  let(:importer) { EstData.new(fixtures_file) }
  let(:articles_hash) { YAML.load_file("#{fixtures_dir}/est_articles.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads est articles from specified resource' do
      allow(importer).to receive(:fetch_data).and_return(File.open(fixtures_file).read)

      expect(Est).to receive(:index) do |articles|
        expect(articles.size).to eq(2)
        2.times { |x| expect(articles[x]).to eq(articles_hash[x]) }
      end
      importer.import
    end
  end
end
