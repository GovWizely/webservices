require 'spec_helper'

describe 'DDTC ITAR Debarred Parties API V2', type: :request do
  include_context 'ScreeningList::Dtc data'
  let(:v2_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v2' } }

  describe 'GET /consolidated_screening_list/dtc/search' do
    let(:params) { {} }
    before { get '/consolidated_screening_list/dtc/search', params, v2_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all ScreeningList::Dtc results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'brian' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Dtc results that match "brian"'

      context 'when search term exists only in name' do
        let(:params) { { q: 'john' } }
        it_behaves_like 'it contains all ScreeningList::Dtc results that match "john"'
      end

      context 'when search term exists only in alt_names' do
        let(:params) { { q: 'mcsulla' } }
        it_behaves_like 'it contains all ScreeningList::Dtc results that match "mcsulla"'
      end
    end

  end
end
