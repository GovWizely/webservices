require 'spec_helper'

describe Envirotech::RegulationData do
  include_context 'empty Envirotech indices'
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/envirotech/regulation_articles/regulation_articles.json" }
  let(:articles_hash) { YAML.load_file("#{File.dirname(__FILE__)}/regulation/regulation_articles.yaml") }

  let(:relational_fixtures_file) { "#{Rails.root}/spec/fixtures/envirotech/relations_data/issue_solution_regulation.json" }
  let(:relational_data) { JSON.parse(open(relational_fixtures_file).read) }

  let(:importer) { described_class.new(fixtures_file, relation_data: relational_data) }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads regulation articles from specified resource' do
      expect(Envirotech::Regulation).to receive(:index) do |articles|
        expect(articles.size).to eq(2)
        2.times { |x| expect(articles[x]).to eq(articles_hash[x]) }
      end
      importer.import
    end
  end
end
