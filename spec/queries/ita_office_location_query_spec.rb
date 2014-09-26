require 'spec_helper'

describe ItaOfficeLocationQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/ita_office_locations" }

  describe '#new' do
    it_behaves_like 'a paginated query'
  end

  describe '#generate_search_body' do
    context 'when options include city' do
      let(:query) { ItaOfficeLocationQuery.new(city: 'San Jose') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_match_city.json").read }

      it 'generates search body with filters' do
        JSON.parse(query.generate_search_body).should == search_body
      end
    end
  end
end
