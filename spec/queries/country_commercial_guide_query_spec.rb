require 'spec_helper'

describe CountryCommercialGuideQuery do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/country_commercial_guide" }

  describe '#generate_search_body' do

    context 'when options is an empty hash' do
      let(:query) { CountryCommercialGuideQuery.new({}) }
      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq({})
      end
    end

    context 'when options include q' do
      let(:query) { CountryCommercialGuideQuery.new(q: 'colombia') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_q_match.json").read }
      it 'generates search body with q matching "colombia"' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include countries' do
      let(:query) { CountryCommercialGuideQuery.new(countries: 'co') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_countries.json").read }
      it 'generates search body with filtered by countries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include topics' do
      let(:query) { CountryCommercialGuideQuery.new(topics: 'automotive - overview') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_topics.json").read }
      it 'generates search body with filtered by topics' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include industries' do
      let(:query) { CountryCommercialGuideQuery.new(industries: 'automotive') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_industries.json").read }
      it 'generates search body with filtered by industries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

  end
end
