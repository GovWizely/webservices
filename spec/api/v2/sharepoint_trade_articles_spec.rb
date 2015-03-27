require 'spec_helper'

describe 'Sharepoint Trade Article API V2', type: :request do
  include_context 'V2 headers'
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/sharepoint_trade_articles"
    fixtures_files = Dir["#{fixtures_dir}/articles/*"].map { |file| open(file) }

    s3 = stubbed_s3_client('sharepoint_trade_article')
    s3.stub_responses(:list_objects, contents: [{ key: '116.xml' }, { key: '117.xml' }, { key: '118.xml' }, { key: '119.xml' }])
    s3.stub_responses(:get_object, { body: fixtures_files[0] }, { body: fixtures_files[1] }, { body: fixtures_files[2] }, body: fixtures_files[3])

    SharepointTradeArticle.recreate_index
    SharepointTradeArticleData.new(s3).import
  end

  let(:search_path) { '/trade_articles/search' }
  let(:expected_results) { YAML.load_file("#{Rails.root}/spec/fixtures/sharepoint_trade_articles/results.yaml") }

  describe 'GET /trade_articles/search.json' do

    context 'when search parameters are empty' do
      before { get search_path, { size: 50 }, @v2_headers }
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
      before { get search_path, params, @v2_headers }
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

    context 'when creation_date is specified' do
      before { get search_path, { creation_date: '2014-08-27 TO 2014-08-28' }, @v2_headers }
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

    context 'when release_date is specified' do
      before { get search_path, { release_date: '2014-08-27 TO 2014-08-28' }, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(0)

      end
    end

    context 'when expiration_date is specified' do
      before { get search_path, { expiration_date: '2014-08-27 TO 2014-08-28' }, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(0)

      end
    end

    context 'when export_phases is specified' do
      before { get search_path, { export_phases: 'expand, learn' }, @v2_headers }
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
      let(:params) { { industries: 'agribusniess,aerospace & defense' } }
      before { get search_path, params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[0])
      end
      it_behaves_like "an empty result when an industries search doesn't match any documents"
    end

    context 'when countries is specified' do
      let(:params) { { countries: 'af,ao' } }
      before { get search_path, params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[0])
      end
      it_behaves_like "an empty result when a countries search doesn't match any documents"
    end

    context 'when topics or sub_topics is specified' do
      before { get search_path, { topics: 'free trade agreements', sub_topics: 'nafta,cafta-dr' }, @v2_headers }
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
      before { get search_path, { geo_regions: 'asia', geo_subregions: 'east asia,asia pacific' }, @v2_headers }
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
      before { get search_path, { trade_regions: 'andean community,african growth and opportunity act' }, @v2_headers }
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
      before { get search_path, { trade_programs: 'advocacy,advisory committees' }, @v2_headers }
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
      before { get search_path, { trade_initiatives: 'discover global markets' }, @v2_headers }
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
