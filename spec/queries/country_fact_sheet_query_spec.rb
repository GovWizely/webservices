require 'spec_helper'

describe CountryFactSheetQuery do
  subject(:query) { described_class.new(params) }
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/country_fact_sheet" }

  describe '#generate_search_body' do
    context 'when options is an empty hash' do
      let(:params) { {} }
      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq({})
      end
    end

    context 'when options include q' do
      let(:params) { { q: 'albania' } }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_q_match.json").read }
      it 'generates search body with q matching "colombia"' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include countries' do
      let(:params) { { countries: 'af' } }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_countries.json").read }
      it 'generates search body with filtered by countries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include topics' do
      let(:params) { { topics: 'foreign relations' } }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_topics.json").read }
      it 'generates search body with filtered by topics' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include sources' do
      let(:params) { { sources: 'state' } }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_sources.json").read }
      it 'generates search body with filtered by sources' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end
end
