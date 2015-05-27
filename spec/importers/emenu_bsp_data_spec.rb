require 'spec_helper'

describe EmenuBspData do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/emenu_bsp" }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/emenu_bsp_articles/emenu_bsp_articles.json" }
  let(:importer) { EmenuBspData.new(fixtures_file) }
  let(:articles_hash) { YAML.load_file("#{fixtures_dir}/emenu_bsp_articles.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads trade articles from specified resource' do
      expect(EmenuBsp).to receive(:index) do |articles|
        expect(articles.size).to eq(3)
        3.times { |x| expect(articles[x]).to eq(articles_hash[x]) }
      end
      importer.import
    end
  end
end
