require 'spec_helper'

describe 'Parature Faq API V1' do
  before(:all) do
    ParatureFaq.recreate_index
    ParatureFaqData.new("#{Rails.root}/spec/fixtures/parature_faqs/parature_faqs.json").import
  end

  let(:search_path) { '/parature_faq/search' }
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }
  let(:expected_results) { JSON.parse open("#{Rails.root}/spec/fixtures/parature_faqs/importer_output.json").read }

  describe 'GET /parature_faq/search.json' do

    context 'when search parameters are empty' do
      before { get search_path, { }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 28

        results = json_response['results']
        10.times { |x| results[x].should == expected_results[x] }

      end
    end

    context 'when q is specified' do
      before { get search_path, { q: 'tpcc' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 1

        results = json_response['results']
        results[0].should == expected_results[1]

      end
    end

    context 'when question is specified' do
      before { get search_path, { question: 'eu' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 1

        results = json_response['results']
        results[0].should == expected_results[4]
        
      end
    end


    context 'when answer is specified' do
      before { get search_path, { answer: 'certificate' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        json_response = JSON.parse(response.body)
        json_response['total'].should == 5

        results = json_response['results']
        results[0].should == expected_results[2]
        results[1].should == expected_results[3]
        results[2].should == expected_results[5]
        results[3].should == expected_results[10]
        results[4].should == expected_results[23]

      end
    end

    context 'when country is specified' do
      before { get search_path, { country: 'tr' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do

        json_response = JSON.parse(response.body)
        json_response['total'].should == 4

        results = json_response['results']
        results[0].should == expected_results[4]
        results[1].should == expected_results[11]
        results[2].should == expected_results[22]
        results[3].should == expected_results[23]

      end
    end

    context 'when industry is specified' do
      before { get search_path, { industry: 'importing' }, v1_headers }
      subject { response }

      it_behaves_like 'a successful search request'

      it 'returns parature faqs' do
        
        json_response = JSON.parse(response.body)
        json_response['total'].should == 1

        results = json_response['results']
        results[0].should == expected_results[27]
        
      end
    end
  end
  
end