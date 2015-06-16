require 'spec_helper'

describe BusinessServiceProviderQuery do
  let(:search_body) do
    JSON.parse(open("#{File.dirname(__FILE__)}/business_service_provider/search_body_with_filters.json").read)
  end
  let(:query) do
    described_class.new(q:           'hospitality alfa',
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
