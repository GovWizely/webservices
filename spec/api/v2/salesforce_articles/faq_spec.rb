require 'spec_helper'

describe 'Salesforce Faq API V2', type: :request do
  include_context 'V2 headers'
  include_context 'ItaTaxonomy data'

  before(:all) do
    fixtures_path = "#{Rails.root}/spec/fixtures/salesforce_articles/faq_sobjects.yml"
    client = StubbedRestforce.new(restforce_collection(fixtures_path))
    SalesforceArticle::Faq.recreate_index
    SalesforceArticle::FaqData.new(client).import
  end

  let(:search_path) { '/v2/ita_faqs/search' }
  let(:expected_results) { JSON.parse(open("#{Rails.root}/spec/support/salesforce_articles/faq/results.json").read) }

  describe 'GET /ita_faqs/search.json' do
    context 'when search parameters are empty' do
      before { get search_path, {}, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns Salesforce faqs' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(2)

        results = json_response['results']
        expect(results).to match_array expected_results
      end

      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'salesforce_articles/faq/aggregations.json' }
      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'exporting' } }
      before { get search_path, params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns Salesforce faqs' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[0])
      end
      it_behaves_like "an empty result when a query doesn't match any documents"

      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'salesforce_articles/faq/aggregations_with_q.json' }
      end
    end

    context 'when countries is specified' do
      let(:params) { { countries: 'cg' } }
      before { get search_path, params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns Salesforce faqs' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[1])
      end
      it_behaves_like "an empty result when a countries search doesn't match any documents"

      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'salesforce_articles/faq/aggregations_with_countries.json' }
      end
    end

    context 'when industries is specified' do
      let(:params) { { industries: 'Business and Professional Services' } }
      before { get search_path, params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns Salesforce faqs' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[1])
      end
      it_behaves_like "an empty result when an industries search doesn't match any documents"
    end

    context 'when topics is specified' do
      let(:params) { { topics: 'Exports, Exporters' } }
      before { get search_path, params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns Salesforce faqs' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when trade regions is specified' do
      let(:params) { { trade_regions: 'African Growth and Opportunity Act' } }
      before { get search_path, params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns Salesforce faqs' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[1])
      end
    end

    context 'when world regions is specified' do
      let(:params) { { world_regions: 'Africa' } }
      before { get search_path, params, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns Salesforce faqs' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[1])
      end
    end

    context 'when first_published_date is specified' do
      before { get search_path, { first_published_date: '2016-03-28 TO 2016-03-29' }, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns Salesforce faqs' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[0])
      end
    end

    context 'when last_published_date is specified' do
      before { get search_path, { last_published_date: '2016-03-29 TO 2016-03-30' }, @v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns Salesforce faqs' do
        json_response = JSON.parse(response.body)
        expect(json_response['total']).to eq(1)

        results = json_response['results']
        expect(results[0]).to eq(expected_results[1])
      end
    end
  end

  describe 'GET /ita_faqs/:id' do
    context 'when trying to retrieve Salesforce FAQ data using a valid id' do
      let(:expected_result) { expected_results.first.symbolize_keys! }
      let(:id) { expected_result[:id] }

      before { get "/v2/ita_faqs/#{id}", nil, @v2_headers }

      subject { response }

      include_examples 'a successful get by id response', source: SalesforceArticle::Faq
    end

    it_behaves_like 'a get by id endpoint with not found response', resource_name: 'ita_faqs'
  end
end
