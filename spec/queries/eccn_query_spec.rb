require 'spec_helper'

describe EccnQuery do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/eccn" }
  let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body.json").read }
  let(:query) do
    EccnQuery.new(q: 'electronics cryptography')
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
  end
end
