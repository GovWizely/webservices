require 'spec_helper'

describe Importable do
  before do
    class Mock
      include Indexable
      analyze_by :snowball_asciifolding_nostop
      self.mappings = {
        name.typeize => {
          properties: {
            _updated_at: { type: 'date', format: 'strictDateOptionalTime' },
          },
        },
      }.merge(metadata_mappings,).freeze
    end

    class MockData
      include Importable

      def initialize(docs = nil)
        @docs = docs
      end

      def import
        model_class.index(@docs)
        ES.client.indices.refresh(index: model_class.index_name)
      end
    end

    class MockQuery < Query
      def generate_search_body
        {}
      end
    end

    Mock.recreate_index
  end

  after do
    Object.send(:remove_const, :Mock)
    Object.send(:remove_const, :MockData)
  end

  describe '#lookup_country' do
    context 'when there is country code' do
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
                         'vietnam',]
        country_names.each do |country_name|
          expect(MockData.new.lookup_country(country_name)).not_to be_nil
        end
      end
    end
    context 'when there is no country code but name is whitelisted' do
      it 'returns nil without logging' do
        expect(Rails.logger).not_to receive(:error)
        expect(MockData.new.lookup_country('undetermined')).to be_nil
      end
    end
    context 'when there is no country code' do
      it 'returns nil and generate an error log' do
        expect(Rails.logger).to receive(:error).with(/Could not find a country code for nowhere republic/)
        expect(MockData.new.lookup_country('nowhere republic')).to be_nil
      end
    end
  end

  describe '#parse_date' do
    subject { MockData.new.parse_date(date_str) }

    context 'when given a parsable string' do
      let(:date_str) { '20 May 1954' }
      it { is_expected.to eq '1954-05-20' }
    end

    context 'when given an ambiguous date string' do
      let(:date_str) { '5/6/1999' }
      it { is_expected.to eq '1999-06-05' }
    end

    context 'when given a non-parsable string' do
      let(:date_str) { 'not a date' }
      it { is_expected.to be_nil }
    end
  end

  describe '#parse_american_date' do
    subject { MockData.new.parse_american_date(date_str) }

    context 'when given a parsable string' do
      let(:date_str) { '5/6/1999' }
      it { is_expected.to eq '1999-05-06' }
    end

    context 'when given a non-parsable string' do
      let(:date_str) { 'not a date' }
      it { is_expected.to be_nil }
    end
  end

  describe '#sanitize_entry' do
    subject { MockData.new.sanitize_entry(hash) }
    let(:hash) { { one: nil, two: ' ', three: ' f ', four: 'o', five: [' o', 'b '] } }
    it { is_expected.to eq(one: nil, two: nil, three: 'f', four: 'o', five: [' o', 'b ']) }

    context 'with HTML in field values' do
      let(:hash) { { one: '<p id="one">One...</p>', two: ' &amp; two' } }
      it { is_expected.to eq(one: 'One...', two: '& two') }
    end
  end

  describe '#model_class' do
    subject { MockData.new.model_class }
    it { is_expected.to eq Mock }
  end

  describe "#import's purge-old logic" do
    let(:batch_1) do
      [{ id: 1, content: 'foo' },
       { id: 2, content: 'bar' },]
    end
    let(:batch_2) do
      [{ id: 1, content: 'foo [updated]' },
       { id: 3, content: 'baz' },]
    end
    let(:batch_3) do
      [{ id: 3, content: 'baz [updated]' }]
    end

    it 'purges correct documents' do
      MockData.new(batch_1).import
      expect(stored_docs).to match_array([a_hash_including(content: 'foo'),
                                          a_hash_including(content: 'bar'),],)

      MockData.new(batch_2).import
      expect(stored_docs).to match_array([a_hash_including(content: 'foo [updated]'),
                                          a_hash_including(content: 'baz'),],)

      MockData.new(batch_3).import
      expect(stored_docs).to match_array([a_hash_including(content: 'baz [updated]')])
    end

    def stored_docs
      Mock.search_for({})[:hits].map { |h| h[:_source].deep_symbolize_keys }
    end
  end
  describe '#import' do
    before do
      Mock.update_metadata('', '')
    end
    it 'stores the last_imported time' do
      expect do
        MockData.new([{ id: 3, content: 'ping pong' }]).import
      end.to change {
        Mock.stored_metadata[:last_imported]
      }.from('',)

      last_imported_time = DateTime.parse(Mock.stored_metadata[:last_imported])
      expect(last_imported_time.to_time).to be_within(60.seconds).of(Time.now)
    end
  end

  describe '#normalize_industry' do
    before(:each) do
      Rails.application.config.enable_industry_mapping_lookup = enable_industry_mapping_lookup
    end
    after(:each) do
      Rails.application.config.enable_industry_mapping_lookup = true
    end
    let(:industry) { 'Agribusiness' }
    context 'when config.enable_industry_mapping_lookup is true' do
      let(:enable_industry_mapping_lookup) { true }
      before(:each) do
        expect(IndustryMappingClient)
          .to receive(:map_industry)
          .with(industry, Mock.to_s,)
          .once
          .and_return(%w(Agribusiness Chemicals),)
      end

      it 'return mapped terms' do
        expect(MockData.new.normalize_industry(industry)).to eq(%w(Agribusiness Chemicals))
      end
    end

    context 'when config.enable_industry_mapping_lookup is false' do
      let(:enable_industry_mapping_lookup) { false }
      it 'return mapped terms' do
        expect(MockData.new.normalize_industry(industry)).to eq(nil)
      end
    end
  end
end
