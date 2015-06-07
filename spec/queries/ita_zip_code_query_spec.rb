require 'spec_helper'

describe ItaZipCodeQuery do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/ita_zip_code" }

  describe '#generate_search_body' do
    context 'when options is an empty hash' do
      let(:query) { ItaZipCodeQuery.new({}) }

      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq({})
      end
    end

    context 'when options include q' do
      let(:query) { ItaZipCodeQuery.new(q: 'long island') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/match_q.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include zip_codes' do
      let(:query) { ItaZipCodeQuery.new(zip_codes: '00501,00544') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/filter_zip_codes.json").read }

      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end
end
