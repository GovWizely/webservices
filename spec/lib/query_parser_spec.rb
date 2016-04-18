require 'spec_helper'

describe QueryParser do
  describe '.parse' do
    before(:all) do
      ItaTaxonomy.recreate_index
      ItaTaxonomyData.new("#{Rails.root}/spec/fixtures/ita_taxonomies/test_data.zip").import
    end

    context 'when query contains a country name' do
      let(:query) { 'United States' }
      let(:expected_results) { { terms: [{ label: 'United States', type: ['Countries'] }], parsed_q: '' } }

      it 'parses terms correctly' do
        expect(QueryParser.parse(query)).to eq(expected_results)
      end
    end

    context 'when query contains tokens that match multiple world regions' do
      context 'and the query includes East Asia' do
        let(:query) { 'East Asia trade' }
        let(:expected_results) { { terms: [{ label: 'East Asia', type: ['World Regions'] }], parsed_q: 'trade' } }

        it 'parses terms correctly' do
          expect(QueryParser.parse(query)).to eq(expected_results)
        end
      end

      context 'and the query includes Asia' do
        let(:query) { 'Asia trade' }
        let(:expected_results) { { terms: [{ label: 'Asia', type: ['World Regions'] }], parsed_q: 'trade' } }

        it 'parses terms correctly' do
          expect(QueryParser.parse(query)).to eq(expected_results)
        end
      end
    end
  end
end
