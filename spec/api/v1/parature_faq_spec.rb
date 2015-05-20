require 'spec_helper'

describe 'Parature Faq API V1', type: :request do
  before(:all) do
    ParatureFaq.recreate_index
    ParatureFaqData.new("#{Rails.root}/spec/fixtures/parature_faqs/articles/article%d.xml",
                        "#{Rails.root}/spec/fixtures/parature_faqs/folders.xml").import
  end

  let(:search_path) { '/ita_faqs/search' }
  let(:expected_results) { YAML.load_file("#{File.dirname(__FILE__)}/parature_faqs/results.yaml") }

  describe 'GET /ita_faqs/search.json' do
    context 'when search parameters are empty' do
      before { get search_path, size: 50 }
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
      let(:params) { { q: 'tpcc' } }
      before { get search_path, params }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[1])
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end

    context 'when question is specified' do
      before { get search_path, question: 'eu' }
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
      before { get search_path, answer: 'nafta' }
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
      let(:params) { { countries: 'tr,cr' } }
      before { get search_path, params }
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
      it_behaves_like "an empty result when a countries search doesn't match any documents"
    end

    context 'when industries is specified' do
      let(:params) { { industries: 'importing' } }
      before { get search_path, params }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(0)
      end

      it_behaves_like "an empty result when an industries search doesn't match any documents"
    end

    context 'when topics is specified' do
      before { get search_path, topics: 'cafta-dr' }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:total]).to eq(1)

        results = json_response[:results]
        expect(results[0]).to eq(expected_results[28])
      end
    end

    context 'when update_date is specified' do
      before { get search_path, update_date: '2013-03-20 TO 2013-04-19' }
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
