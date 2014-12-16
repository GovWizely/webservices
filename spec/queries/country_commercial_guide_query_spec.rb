require 'spec_helper'

describe CountryCommercialGuideQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/country_commercial_guides" }

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

  end
end