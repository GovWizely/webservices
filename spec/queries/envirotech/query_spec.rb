require 'spec_helper'

describe Envirotech::Query do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/query" }
  let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_filters.json").read }
  let(:query) do
    Envirotech::Query.new(q: 'Precipitators')
  end

  describe '#new' do
    it_behaves_like 'a paginated query'
  end

  describe '#generate_search_body' do
    context 'when search terms exist in different fields' do
      it 'it generates a multi_match query' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when searching for solution_ids' do
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_solution_ids.json").read }
      let(:query) { Envirotech::Query.new(solution_ids: '100,101') }

      it 'it generates a bool filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end
end
