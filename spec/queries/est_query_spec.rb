require 'spec_helper'

describe EstQuery do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/est" }
  let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_filters.json").read }
  let(:query) do
    EstQuery.new(q: 'Precipitators')
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
  end
end
