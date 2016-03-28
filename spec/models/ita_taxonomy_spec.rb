require 'spec_helper'

describe ItaTaxonomy, type: :model do
  before(:all) do
    Rails.application.config.enable_related_term_lookups = true
    ItaTaxonomy.recreate_index
    ItaTaxonomyData.new("#{Rails.root}/spec/fixtures/ita_taxonomies/test_data.zip").import
  end

  let(:expected_results) { YAML.load_file("#{Rails.root}/spec/models/ita_taxonomy/related_term_results.yaml") }

  after(:all) { Rails.application.config.enable_related_term_lookups = false }

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
  end
end
