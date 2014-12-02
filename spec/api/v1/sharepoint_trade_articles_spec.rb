require 'spec_helper'

describe 'Sharepoint Trade Article API V1', type: :request do
  before(:all) do
    SharepointTradeArticle.recreate_index
    SharepointTradeArticleData.new("#{Rails.root}/spec/fixtures/sharepoint_trade_articles/articles/*").import
  end

  let(:search_path) { '/ita_articles/search' }
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { YAML.load_file("#{Rails.root}/spec/fixtures/sharepoint_trade_articles/results.yaml") }

  describe 'GET /ita_articles/search.json' do

    context 'when search parameters are empty' do
      before { get search_path, { size: 50 }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(4)

        results = json_response[:results]
        expect(results).to match_array expected_results

      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'import' } }
      before { get search_path, params, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[2])

      end

      it_behaves_like "an empty result when a query doesn't match any documents"
    end

    context 'when creation_date_start or creation_date_end is specified' do
      before { get search_path, { creation_date_start: '2014-08-27', creation_date_end: '2014-08-28' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(3)

        results = json_response[:results]
        expect(results).to include expected_results[0]
        expect(results).to include expected_results[2]
        expect(results).to include expected_results[3]
      end
    end

    context 'when release_date_start or release_date_end is specified' do
      before { get search_path, { release_date_start: '2014-08-27', release_date_end: '2014-08-28' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(0)

      end
    end

    context 'when expiration_date_start or expiration_date_end is specified' do
      before { get search_path, { expiration_date_start: '2014-08-27', expiration_date_end: '2014-08-28' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(0)

      end
    end

    context 'when export_phases is specified' do
      before { get search_path, { export_phases: 'expand, learn' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when industries is specified' do
      before { get search_path, { industries: 'agribusniess,aerospace & defense' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when countries is specified' do
      before { get search_path, { countries: 'af,ao' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when topics or sub_topics is specified' do
      before { get search_path, { topics: 'free trade agreements', sub_topics: 'nafta,cafta-dr' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when geo_regions or geo_subregions is specified' do
      before { get search_path, { geo_regions: 'asia', geo_subregions: 'east asia,asia pacific' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when trade_regions is specified' do
      before { get search_path, { trade_regions: 'andean community,african growth and opportunity act' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when trade_programs is specified' do
      before { get search_path, { trade_programs: 'advocacy,advisory committees' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when trade_initiatives is specified' do
      before { get search_path, { trade_initiatives: 'discover global markets' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[0])
      end
    end

  end

end
