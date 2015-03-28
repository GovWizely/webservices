require 'spec_helper'

describe 'BIS Unverified Parties API V1', type: :request do
  include_context 'ScreeningList::Uvl data'
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /consolidated_screening_list/uvl/search' do
    let(:params) { { size: 100 } }
    before { get '/consolidated_screening_list/uvl/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all ScreeningList::Uvl results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'technology' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Uvl results that match "technology", sorted correctly'

      context 'when search term exists only in name' do
        let(:params) { { q: 'brilliance' } }
        let(:source) { ScreeningList::Uvl }
        let(:expected) { [1] }
        it_behaves_like 'it contains all expected results of source'
      end
    end

    context 'when countries is specified' do
      subject { response }

      context 'and one country is searched for' do
        let(:params) { { countries: 'CN' } }
        it_behaves_like 'a successful search request'
        let(:source) { ScreeningList::Uvl }
        let(:expected) { [2] }
        it_behaves_like 'it contains all expected results of source'
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'hk,cn' } }
        it_behaves_like 'a successful search request'
        let(:source) { ScreeningList::Uvl }
        let(:expected) { (1..7).to_a }
        it_behaves_like 'it contains all expected results of source'
      end
    end

  end
end
