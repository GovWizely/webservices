require 'spec_helper'

describe ItaTaxonomy, type: :model do
  before(:all) do
    ItaTaxonomy.recreate_index
    ItaTaxonomyData.new("#{Rails.root}/spec/fixtures/ita_taxonomies/test_data.zip").import
  end

  let(:expected_results) { YAML.load_file("#{Rails.root}/spec/models/ita_taxonomy/related_term_results.yaml") }

  describe '.search_related_terms' do
    context 'when the query is empty' do
      it 'returns all results' do
        results = ItaTaxonomy.search_related_terms({})
        expect(results).to match_array(expected_results)
      end
    end

    context 'when a query and type is specified' do
      it 'returns the correct result' do
        results = ItaTaxonomy.search_related_terms(q: 'tech in china', types: 'countries')
        expect(results.count).to eq(1)
        expect(results).to include(expected_results[0])
      end
    end

    context 'when the query term matches multiple possible results' do
      context 'and the query term is Asia' do
        it 'returns the correct result first' do
          results = ItaTaxonomy.search_related_terms(q: 'Asia', types: 'world regions')
          expect(results.count).to eq(3)
          expect(results[0]).to eq(expected_results[5])
        end
      end

      context 'and the query term is East Asia' do
        it 'returns the correct result first' do
          results = ItaTaxonomy.search_related_terms(q: 'East Asia', types: 'world regions')
          expect(results.count).to eq(3)
          expect(results[0]).to eq(expected_results[6])
        end
      end
    end
  end
end
