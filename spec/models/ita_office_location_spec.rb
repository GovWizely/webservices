require 'spec_helper'

describe ItaOfficeLocation do
  before(:all) do
    ItaOfficeLocation.recreate_index
    fixtures_dir = "#{Rails.root}/spec/fixtures/ita_office_locations"
    ItaOfficeLocationData.new(["#{fixtures_dir}/odo.xml", "#{fixtures_dir}/oio.xml"]).import
  end

  describe '.search_for' do

    it 'should return results sorted by post' do
      alphabetized_posts = ["Belo Horizonte", "Brasilia", "Recife", "Rio De Janeiro", "Sao Paulo"]
      ItaOfficeLocation.search_for(country: 'BR')[:hits].collect { |h| h['_source']['post'] }.should == alphabetized_posts
    end

    context 'when options is an empty hash' do
      it 'finds all hits' do
        ItaOfficeLocation.search_for({})[:total].should == 229
      end
    end

    context 'when looking up locations in a country' do
      it 'finds all hits in that country' do
        ItaOfficeLocation.search_for(country: 'Br')[:total].should == 5
      end
    end

    context 'when looking up locations in a US state' do
      it 'finds all hits in that state' do
        ItaOfficeLocation.search_for(state: 'Dc', country: 'US')[:total].should == 2
        ItaOfficeLocation.search_for(state: 'Fl')[:total].should == 6
      end
    end

    context 'when searching by name for a location' do
      it 'should return matches' do
        ItaOfficeLocation.search_for(q: 'kabul')[:total].should == 1
        ItaOfficeLocation.search_for(q: 'afghanistan')[:total].should == 1
        ItaOfficeLocation.search_for(q: 'sao paulo')[:total].should == 1
        ItaOfficeLocation.search_for(q: 'São paulo')[:total].should == 1
        ItaOfficeLocation.search_for(q: 'Saint Petersburg')[:total].should == 1
        ItaOfficeLocation.search_for(q: 'St Petersburg')[:total].should == 1
      end
    end

    context 'when searching by name for a city' do
      it 'should return matches' do
        ItaOfficeLocation.search_for(city: 'san jose')[:total].should == 2
        ItaOfficeLocation.search_for(city: 'São paulo')[:total].should == 1
        ItaOfficeLocation.search_for(city: 'Fort Lauderdale')[:total].should == 1
        ItaOfficeLocation.search_for(city: 'Ft Lauderdale')[:total].should == 1
        ItaOfficeLocation.search_for(city: 'St Petersburg')[:total].should == 1
        ItaOfficeLocation.search_for(city: 'Saint Petersburg')[:total].should == 1
      end
    end

    context 'when searching for generic common terms' do
      it 'should not return matches' do
        ItaOfficeLocation::STOPWORDS.each do |stopword|
          ItaOfficeLocation.search_for(q: stopword)[:total].should be_zero
        end
      end

      it 'should still have common terms in result entries' do
        ItaOfficeLocation.search_for(q: 'European')[:hits].first['_source']['office_name'].should == 'U.S. Mission to the European Union'
      end
    end

  end
end
