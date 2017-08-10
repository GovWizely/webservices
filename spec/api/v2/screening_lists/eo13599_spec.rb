require 'spec_helper'

describe 'Eo13599 List API V2', type: :request do
  include_context 'V2 headers'
  include_context 'ScreeningList::Eo13599 data'
  let(:v2_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v2' } }

  describe 'GET /consolidated_screening_list/search?sources=13599' do
    let(:params) { { sources: '13599' } }
    before { get '/v2/consolidated_screening_list/search', params, @v2_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all ScreeningList::Eo13599 results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { sources: '13599', q: 'kuo' } }
      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Eo13599 results that match "kuo"'
    end

    context 'when countries is specified' do
      let(:params) { { sources: '13599', countries: 'AE' } }
      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Eo13599 results that match countries "AE"'
    end

    context 'when type is specified' do
      subject { response }
      let(:params) { { sources: '13599', type: 'Entity' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Eo13599 results that match type "Entity"'
    end
  end
end
