require 'spec_helper'

describe EmenuBspQuery do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/emenu_bsp" }
  let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_filters.json").read }
  let(:query) do
    EmenuBspQuery.new(q:           'hospitality alfa',
                      ita_offices: 'egypt,bulgaria',
                      categories:  'electronic components and supplies,advertising')
  end

  describe '#new' do
    it_behaves_like 'a paginated query'
  end

  describe '#generate_search_body' do
    context 'when search terms exist in different fields' do
      it 'it generates a multi_match query' do
        expect(JSON.parse(query.generate_search_body)['query']).to eq(search_body['query'])
      end
    end

    context 'when filtering by multiple countries' do
      it 'it generates a terms filter' do
        expect(JSON.parse(query.generate_search_body)['filter']).to eq(search_body['filter'])
      end
    end
  end
end
