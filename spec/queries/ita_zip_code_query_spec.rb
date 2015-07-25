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

  context 'sorts results by zip_code' do
    it 'includes zip_code on the sort order' do
      # Not a great test. Just to document the sorting as a requirement.
      expect(ItaZipCodeQuery.new({}).sort).to eq('_score,zip_code:asc')
    end

    it 'uses global IDF on queries' do
      # Minimal differences in the local IDF and sorting first by relevance makes the whole
      # thing useless (only relevance, no zip_code ordering), so we force this index to
      # calculate global IDF
      expect(ItaZipCodeQuery.new({}).search_type).to eq(:dfs_query_then_fetch)
    end
  end
end
