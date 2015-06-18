require 'spec_helper'

describe EnvironmentalSolutionData do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/environmental_solution" }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/environmental_solution_articles/environmental_solution_articles.json" }
  let(:importer) { EnvironmentalSolutionData.new(fixtures_file) }
  let(:articles_hash) { YAML.load_file("#{fixtures_dir}/environmental_solution_articles.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads environmental_solution articles from specified resource' do
      allow(importer).to receive(:fetch_data).and_return(JSON.parse File.open(fixtures_file).read)

      expect(EnvironmentalSolution).to receive(:index) do |articles|
        expect(articles.size).to eq(2)
        2.times { |x| expect(articles[x]).to eq(articles_hash[x]) }
      end
      importer.import
    end
  end
end
