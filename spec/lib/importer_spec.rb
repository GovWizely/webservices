require 'spec_helper'

describe Importer do
  class MockImporter
    include Importer
  end

  describe '#lookup_country' do
    it "finds alpha2 code" do
      country_names = ['burma (Myanmar)',
                       "cote d'Ivoire",
                       'congo, Democratic Rep. of the',
                       'congo, Republic of the',
                       'Democratic Republic of Congo',
                       'korea (South)',
                       'kosovo',
                       'Republic of the Congo',
                       'São Tomé & Príncipe',
                       'south Korea',
                       'St. Lucia',
                       'vietnam']
      country_names.each do |country_name|
        MockImporter.new.lookup_country(country_name).should_not be_nil
      end
    end
  end

  describe '#parse_date' do
    subject { MockImporter.new.parse_date(date_str) }

    context 'when given a parsable string' do
      let(:date_str) { '20 May 1954' }
      it { should eq '1954-05-20' }
    end

    context 'when given an ambiguous date string' do
      let(:date_str) { '5/6/1999' }
      it { should eq '1999-06-05' }
    end

    context 'when given a non-parsable string' do
      let(:date_str) { 'not a date' }
      it { should be_nil }
    end
  end

  describe '#parse_date' do
    subject { MockImporter.new.parse_american_date(date_str) }

    context 'when given a parsable string' do
      let(:date_str) { '5/6/1999' }
      it { should eq '1999-05-06' }
    end

    context 'when given a non-parsable string' do
      let(:date_str) { 'not a date' }
      it { should be_nil }
    end
  end

  describe '#sanitize_entry' do
    subject { MockImporter.new.sanitize_entry(hash) }
    let(:hash) { {one: nil, two: ' ', three: ' f ', four: 'o', five: [' o', 'b ']} }
    it { should eq({one: nil, two: nil, three: 'f', four: 'o', five: [' o', 'b ']}) }
  end

  describe '#lookup_country_with_coordinates' do
    subject { MockImporter.new.lookup_country_with_coordinates(coords) }

    context 'with coordinates in Columbia' do
      let(:coords) { {latitude: 4.570868, longitude: -74.29733299999998} }
      it { should eq 'CO' }
    end

    context 'with coordinates in Philippines' do
      let(:coords) { {latitude: 12.879721, longitude: 121.77401699999996} }
      it { should eq 'PH' }
    end

    context 'with coordinates in Qatar' do
      let(:coords) { {latitude: 25.2942804, longitude: 51.4978033} }
      it { should eq 'QA' }
    end

    context 'with coordinates in Kenya' do
      let(:coords) { {latitude: -0.023559, longitude: 37.906193} }
      it { should eq 'KE' }
    end

    context 'with coordinates in Greece' do
      let(:coords) { {latitude: 38.01632499999999, longitude: 23.785365800000022} }
      it { should eq 'GR' }
    end

  end
end
