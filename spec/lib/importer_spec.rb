require 'spec_helper'

describe Importer do
  before(:all) do
    class Mock
    end
    class MockData
      include Importer
    end
  end

  after(:all) do
    Object.send(:remove_const, :Mock)
    Object.send(:remove_const, :MockData)
  end

  describe '#lookup_country' do
    it 'finds alpha2 code' do
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
        MockData.new.lookup_country(country_name).should_not be_nil
      end
    end
  end

  describe '#parse_date' do
    subject { MockData.new.parse_date(date_str) }

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
    subject { MockData.new.parse_american_date(date_str) }

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
    subject { MockData.new.sanitize_entry(hash) }
    let(:hash) { { one: nil, two: ' ', three: ' f ', four: 'o', five: [' o', 'b '] } }
    it { should eq(one: nil, two: nil, three: 'f', four: 'o', five: [' o', 'b ']) }
  end

  describe '.model_class' do
    subject { MockData.new.model_class }
    it { should eq Mock }
  end

end
