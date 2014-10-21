require 'spec_helper'

describe 'Sharepoint Trade Article API V1' do
  before(:all) do
    SharepointTradeArticle.recreate_index
    SharepointTradeArticleData.new("#{Rails.root}/spec/fixtures/sharepoint_trade_articles/articles/%d.xml").import
  end

  let(:search_path) { '/sharepoint_trade_articles/search' }
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { YAML.load_file("#{Rails.root}/spec/fixtures/sharepoint_trade_articles/results.yaml") }

  describe 'GET /sharepoint_trade_articles/search.json' do

    context 'when search parameters are empty' do
      before { get search_path, { size: 50 }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 4

        results = json_response[:results]
        results.should match_array expected_results

      end
    end

    context 'when q is specified' do
      before { get search_path, { q: 'import' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 1

        results = json_response[:results]
        results[0].should == expected_results[2]

      end
    end

    context 'when creation_date_start or creation_date_end is specified' do
      before { get search_path, { creation_date_start: '2014-08-27', creation_date_end: '2014-08-28' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 3

        results = json_response[:results]
        results.should include expected_results[0]
        results.should include expected_results[2]
        results.should include expected_results[3]
      end
    end

    context 'when release_date_start or release_date_end is specified' do
      before { get search_path, { release_date_start: '2014-08-27', release_date_end: '2014-08-28' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 0

      end
    end

    context 'when expiration_date_start or expiration_date_end is specified' do
      before { get search_path, { expiration_date_start: '2014-08-27', expiration_date_end: '2014-08-28' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 0

      end
    end

    context 'when source_agencies or source_business_units or source_offices is specified' do
      before { get search_path, { source_agencies: 'trade', source_business_units: 'markets', source_offices: 'director general' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 1

        results = json_response[:results]
        results.should include expected_results[0]
      end
    end

    context 'when export_phases is specified' do
      before { get search_path, { export_phases: 'expand' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 1

        results = json_response[:results]
        results[0].should == expected_results[0]
      end
    end

    context 'when industries is specified' do
      before { get search_path, { industries: 'defense' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 1

        results = json_response[:results]
        results[0].should == expected_results[0]
      end
    end

    context 'when countries is specified' do
      before { get search_path, { countries: 'af,ao' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 1

        results = json_response[:results]
        results[0].should == expected_results[0]
      end
    end

    context 'when topics or sub_topics is specified' do
      before { get search_path, { topics: 'free trade', sub_topics: 'nafta' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 1

        results = json_response[:results]
        results[0].should == expected_results[0]
      end
    end

    context 'when geo_regions or geo_subregion is specified' do
      before { get search_path, { geo_regions: 'asia', geo_subregion: 'east' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 1

        results = json_response[:results]
        results[0].should == expected_results[0]
      end
    end

    context 'when trade_regions is specified' do
      before { get search_path, { trade_regions: 'asia' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 1

        results = json_response[:results]
        results[0].should == expected_results[0]
      end
    end

    context 'when trade_programs is specified' do
      before { get search_path, { trade_programs: 'advisory' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 1

        results = json_response[:results]
        results[0].should == expected_results[0]
      end
    end

    context 'when trade_initiatives is specified' do
      before { get search_path, { trade_initiatives: 'discover' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns sharepoint trade articles' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 1

        results = json_response[:results]
        results[0].should == expected_results[0]
      end
    end

  end

end
