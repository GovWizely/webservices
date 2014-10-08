require 'spec_helper'

describe 'Parature Faq API V1' do
  before(:all) do
    ParatureFaq.recreate_index
    ParatureFaqData.new("#{Rails.root}/spec/fixtures/parature_faqs/articles/article%d.xml").import
  end

  let(:search_path) { '/faqs/search' }
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { YAML.load_file("#{Rails.root}/spec/fixtures/parature_faqs/importer_output.yaml") }

  describe 'GET /parature_faq/search.json' do

    context 'when search parameters are empty' do
      before { get search_path, { size: 50 }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 29

        results = json_response[:results]
        results.should match_array expected_results

      end
    end

    context 'when q is specified' do
      before { get search_path, { q: 'tpcc' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 1

        results = json_response[:results]
        results[0].should == expected_results[1]

      end
    end

    context 'when question is specified' do
      before { get search_path, { question: 'eu' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 2

        results = json_response[:results]
        results.should include expected_results[4]
        results.should include expected_results[18]
      end
    end

    context 'when answer is specified' do
      before { get search_path, { answer: 'nafta' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 2

        results = json_response[:results]
        results.should include expected_results[26]
        results.should include expected_results[28]
      end
    end

    context 'when countries is specified' do
      before { get search_path, { countries: 'tr,cr' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 5

        results = json_response[:results]
        results.should include expected_results[4]
        results.should include expected_results[11]
        results.should include expected_results[22]
        results.should include expected_results[23]
        results.should include expected_results[28]
      end
    end

    context 'when industry is specified' do
      before { get search_path, { industry: 'importing' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 1

        results = json_response[:results]
        results[0].should == expected_results[27]
      end
    end

    context 'when update_date_start or update_date_end is specified' do
      before { get search_path, { update_date_start: '2013-03-20', update_date_end: '2013-04-19' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do

        json_response = JSON.parse(response.body, symbolize_names: true)
        json_response[:total].should == 6

        results = json_response[:results]
        results.should include expected_results[1]
        results.should include expected_results[21]
        results.should include expected_results[24]
        results.should include expected_results[25]
        results.should include expected_results[26]
        results.should include expected_results[28]
      end
    end
  end

end
