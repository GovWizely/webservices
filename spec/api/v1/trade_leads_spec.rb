require 'spec_helper'

describe 'Trade Leads API V1', type: :request do
  before(:all) do
    TradeLead::Australia.recreate_index
    TradeLead::Canada.recreate_index
    TradeLead::Fbopen.recreate_index
    TradeLead::State.recreate_index
    TradeLead::Uk.recreate_index
    TradeLead::Mca.recreate_index
    VCR.use_cassette('importers/trade_leads/fbopen/presol_source.yml', record: :once) do
      TradeLead::FbopenImporter::PatchData.new("#{Rails.root}/spec/fixtures/trade_leads/fbopen/presol_source").import
    end
    VCR.use_cassette('importers/trade_leads/canada.yml', record: :once) do
      TradeLead::CanadaData.new("#{Rails.root}/spec/fixtures/trade_leads/canada/canada_leads.csv").import
    end
    VCR.use_cassette('importers/trade_leads/uk.yml', record: :once) do
      TradeLead::UkData.new("#{Rails.root}/spec/fixtures/trade_leads/uk/Notices.xml").import
    end
    VCR.use_cassette('importers/trade_leads/state.yml', record: :once) do
      TradeLead::StateData.new("#{Rails.root}/spec/fixtures/trade_leads/state/state_trade_leads.json").import
    end
    VCR.use_cassette('importers/trade_leads/mca.yml', record: :once) do
      TradeLead::McaData.new("#{Rails.root}/spec/fixtures/trade_leads/mca/mca_leads.xml").import
    end
  end

  before do
    allow(Date).to receive(:today).and_return(Date.parse('2015-12-18'))
    TradeLead::Ustda.recreate_index
    VCR.use_cassette('importers/trade_leads/ustda.yml', record: :once) do
      TradeLead::UstdaData.new("#{Rails.root}/spec/fixtures/trade_leads/ustda/leads.xml",
        "#{Rails.root}/spec/fixtures/trade_leads/ustda/rss.xml" ).import
    end
  end

  let(:expected_results) { JSON.parse Rails.root.join("#{File.dirname(__FILE__)}/trade_leads/expected_results.json").read }

  describe 'GET /v1/trade_leads/search.json' do
    context 'when search parameters are empty' do
      before { get '/v1/trade_leads/search' }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade leads sorted by published_date:desc, country: asc' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(24)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results).to match_array(expected_results.first(10))
      end
    end

    context 'when size is specified' do
      before { get '/v1/trade_leads/search', size: 100 }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns up to the specified size' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(24)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results).to match_array(expected_results)
      end
    end

    context 'when countries is populated' do
      let(:params) { { countries: 'CA' } }
      before { get '/v1/trade_leads/search', params }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade leads sorted by id in descending order' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(5)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[14])
        expect(results[1]).to eq(expected_results[15])
        expect(results[2]).to eq(expected_results[16])
        expect(results[3]).to eq(expected_results[17])
        expect(results[4]).to eq(expected_results[19])
      end
      it_behaves_like "an empty result when a countries search doesn't match any documents"
    end

    context 'when industries is populated' do
      let(:params) { { industries: 'dental' } }
      before { get '/v1/trade_leads/search', params }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns trade leads for matching industries' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results).to include *expected_results.values_at(14)
      end
      it_behaves_like "an empty result when an industries search doesn't match any documents"
    end

    context 'when q matches a title' do
      let(:params) { { q: 'physician service' } }
      before { get '/v1/trade_leads/search', params }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns relevant trade leads' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[14])
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end

    context 'when q matches a description' do
      before { get '/v1/trade_leads/search', q: 'ambulatory' }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns relevant trade leads' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)
        expect(json_response['offset']).to eq(0)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[18])
      end
    end
  end
end
