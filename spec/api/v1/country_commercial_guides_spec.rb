require 'spec_helper'

describe 'Country Commercial Guide API V1', type: :request do

  before(:all) do
    CountryCommercialGuide.recreate_index
    CountryCommercialGuideData.new(
      "#{Rails.root}/spec/fixtures/country_commercial_guides").import
    @all_possible_full_results =
      YAML.load_file("#{File.dirname(__FILE__)}/country_commercial_guide/results.yaml")
  end

  let(:search_path) { '/country_commercial_guides/search' }
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:params) { { size: 100 } }
  subject { response }

  describe 'GET /country_commercial_guides/search.json' do

    context 'when search parameters are empty' do
      before { get search_path, params, v1_headers }

      it_behaves_like 'a successful search request'

      it 'returns country commercial guide sections' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(21)
        results = json_response[:results]
        expect(results).to match_array(@all_possible_full_results)
      end
    end

    context 'when q is specified' do
      context 'and is set to "defense"' do
        before do
          params[:q] = 'defense'
          get search_path, params, v1_headers
        end
        let(:expected) { [5] }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all expected results'
      end

      context 'and is set to "sector"' do
        before do
          params[:q] = 'sector'
          get search_path, params, v1_headers
        end
        let(:expected) { [1, 2, 4, 5, 9, 10, 11, 12, 13, 14, 15, 18] }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all expected results'
      end
    end

    context 'when countries is specified' do
      context 'and is set to "AR"' do
        before do
          params[:countries] = 'AR'
          get search_path, params, v1_headers
        end
        let(:expected) { [0, 1, 2, 3, 4, 5, 6, 7] }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all expected results'
      end

      context 'and is set to "CN"' do
        before do
          params[:countries] = 'CN'
          get search_path, params, v1_headers
        end
        let(:expected) { [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20] }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all expected results'
      end

      context 'and is set to "GB"' do
        before do
          params[:countries] = 'GB'
          get search_path, params, v1_headers
        end
        let(:expected) { [] }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all expected results'
      end
    end

    context 'when topics is specified' do
      context 'and is set to "Business Customs"' do
        before do
          params[:topics] = 'Business Customs'
          get search_path, params, v1_headers
        end
        let(:expected) { [3] }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all expected results'
      end

      context 'and is set to "Business"' do
        before do
          params[:topics] = 'Business'
          get search_path, params, v1_headers
        end
        let(:expected) { [] }  # i.e. topics search does an exact match.
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all expected results'
      end

      context 'and is set to find multiple topics' do
        before do
          params[:topics] = 'Visa Requirements,Standards Overview'
          get search_path, params, v1_headers
        end
        let(:expected) { [2, 19] }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all expected results'
      end
    end

    context 'when industries is specified' do
      context 'and is set to "Green Building"' do
        before do
          params[:industries] = 'Green Building'
          get search_path, params, v1_headers
        end
        let(:expected) { [13] }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all expected results'
      end

      context 'and is set to "Building"' do
        before do
          params[:industries] = 'Building'
          get search_path, params, v1_headers
        end
        let(:expected) { [] }  # i.e. industries search does an exact match.
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all expected results'
      end

      context 'and is set to find multiple industries' do
        before do
          params[:industries] = 'Agriculture,ICT Equipment and Software'
          get search_path, params, v1_headers
        end
        let(:expected) { [12, 14, 15] }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all expected results'
      end
    end

  end
end
