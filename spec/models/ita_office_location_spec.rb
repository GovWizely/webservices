require 'spec_helper'

describe ItaOfficeLocation, type: :model do
  before(:all) do
    ItaOfficeLocation.recreate_index
    fixtures_dir = "#{Rails.root}/spec/fixtures/ita_office_locations"
    ItaOfficeLocationData.new(["#{fixtures_dir}/odo.xml", "#{fixtures_dir}/oio.xml"]).import
  end

  describe '.search_for' do

    it 'should return results sorted by post' do
      alphabetized_posts = ['Belo Horizonte', 'Brasilia', 'Recife', 'Rio De Janeiro', 'Sao Paulo']
      expect(ItaOfficeLocation.search_for(country: 'BR')[:hits].map { |h| h['_source']['post'] }).to eq(alphabetized_posts)
    end

    context 'when options is an empty hash' do
      it 'finds all hits' do
        expect(ItaOfficeLocation.search_for({})[:total]).to eq(229)
      end
    end

    context 'when looking up locations in a country' do
      it 'finds all hits in that country' do
        expect(ItaOfficeLocation.search_for(country: 'Br')[:total]).to eq(5)
      end
    end

    context 'when looking up locations in a US state' do
      it 'finds all hits in that state' do
        expect(ItaOfficeLocation.search_for(state: 'Dc', country: 'US')[:total]).to eq(2)
        expect(ItaOfficeLocation.search_for(state: 'Fl')[:total]).to eq(6)
      end
    end

    context 'when searching by name for a location' do
      it 'should return matches' do
        expect(ItaOfficeLocation.search_for(q: 'kabul')[:total]).to eq(1)
        expect(ItaOfficeLocation.search_for(q: 'afghanistan')[:total]).to eq(1)
        expect(ItaOfficeLocation.search_for(q: 'sao paulo')[:total]).to eq(1)
        expect(ItaOfficeLocation.search_for(q: 'São paulo')[:total]).to eq(1)
        expect(ItaOfficeLocation.search_for(q: 'Saint Petersburg')[:total]).to eq(1)
        expect(ItaOfficeLocation.search_for(q: 'St Petersburg')[:total]).to eq(1)
      end
    end

    context 'when searching by name for a city' do
      it 'should return matches' do
        expect(ItaOfficeLocation.search_for(city: 'san jose')[:total]).to eq(2)
        expect(ItaOfficeLocation.search_for(city: 'São paulo')[:total]).to eq(1)
        expect(ItaOfficeLocation.search_for(city: 'Fort Lauderdale')[:total]).to eq(1)
        expect(ItaOfficeLocation.search_for(city: 'Ft Lauderdale')[:total]).to eq(1)
        expect(ItaOfficeLocation.search_for(city: 'St Petersburg')[:total]).to eq(1)
        expect(ItaOfficeLocation.search_for(city: 'Saint Petersburg')[:total]).to eq(1)
      end
    end

    context 'when searching for generic common terms' do
      it 'should not return matches' do
        ItaOfficeLocation::STOPWORDS.each do |stopword|
          expect(ItaOfficeLocation.search_for(q: stopword)[:total]).to be_zero
        end
      end

      it 'should still have common terms in result entries' do
        expect(ItaOfficeLocation.search_for(q: 'European')[:hits].first['_source']['office_name']).to eq('U.S. Mission to the European Union')
      end
    end

  end
end
