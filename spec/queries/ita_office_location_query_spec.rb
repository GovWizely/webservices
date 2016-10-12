require 'spec_helper'

describe ItaOfficeLocationQuery do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/ita_office_location" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    context 'when options does not include q' do
      subject { described_class.new(countries: 'BR,RU') }

      it { is_expected.to have_attributes(sort: %i(post.sort)) }
    end
  end

  describe '#generate_search_body' do
    context 'when options include city' do
      let(:query) { ItaOfficeLocationQuery.new(city: 'San Jose') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_match_city.json").read }

      it 'generates search body with filters' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include country' do
      let(:query) { ItaOfficeLocationQuery.new(countries: 'BR,RU') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_filter_countries.json").read }

      it 'generates search body with filters' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end
end
