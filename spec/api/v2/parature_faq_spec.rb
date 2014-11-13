require 'spec_helper'

describe 'Parature Faq API V2', type: :request do
  before(:all) do
    ParatureFaq.recreate_index
    ParatureFaqData.new("#{Rails.root}/spec/fixtures/parature_faqs/articles/article%d.xml").import
  end

  let(:search_path) { '/faqs/search' }
  let(:v2_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v2' } }
  let(:expected_results) { YAML.load_file("#{Rails.root}/spec/fixtures/parature_faqs/importer_output.yaml") }

  describe 'GET /faqs/search.json' do

    context 'when search parameters are empty' do
      before { get search_path, { size: 50 }, v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(29)

        results = json_response[:results]
        expect(results).to match_array expected_results

      end
    end

    context 'when q is specified' do
      before { get search_path, { q: 'tpcc' }, v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[1])

      end
    end

    context 'when question is specified' do
      before { get search_path, { question: 'eu' }, v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(2)

        results = json_response[:results]
        expect(results).to include expected_results[4]
        expect(results).to include expected_results[18]
      end
    end

    context 'when answer is specified' do
      before { get search_path, { answer: 'nafta' }, v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(2)

        results = json_response[:results]
        expect(results).to include expected_results[26]
        expect(results).to include expected_results[28]
      end
    end

    context 'when countries is specified' do
      before { get search_path, { countries: 'tr,cr' }, v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(5)

        results = json_response[:results]
        expect(results).to include expected_results[4]
        expect(results).to include expected_results[11]
        expect(results).to include expected_results[22]
        expect(results).to include expected_results[23]
        expect(results).to include expected_results[28]
      end
    end

    context 'when industries is specified' do
      before { get search_path, { industries: 'importing' }, v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[27])
      end
    end

    context 'when topics is specified' do
      before { get search_path, { topics: 'cafta-dr' }, v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[28])
      end
    end

    context 'when update_date_start or update_date_end is specified' do
      before { get search_path, { update_date_start: '2013-03-20', update_date_end: '2013-04-19' }, v2_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(6)

        results = json_response[:results]
        expect(results).to include expected_results[1]
        expect(results).to include expected_results[21]
        expect(results).to include expected_results[24]
        expect(results).to include expected_results[25]
        expect(results).to include expected_results[26]
        expect(results).to include expected_results[28]
      end
    end
  end

end
