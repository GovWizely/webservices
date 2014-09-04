require 'spec_helper'

describe 'DDTC AECA Debarred Parties API V1' do
  include_context 'DTC data'
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /aeca_debarred_list/search' do
    let(:params) { {} }
    before { get '/aeca_debarred_list/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all DTC results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'brian' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all DTC results that match "brian"'

      context 'when search term exists only in name' do
        let(:params) { { q: 'john' } }
        it_behaves_like 'it contains all DTC results that match "john"'
      end

      context 'when search term exists only in alt_names' do
        let(:params) { { q: 'mcsulla' } }
        it_behaves_like 'it contains all DTC results that match "mcsulla"'
      end

      context 'when search term exists only in remarks' do
        let(:params) { { q: 'original' } }
        it_behaves_like 'it contains all DTC results that match "original"'
      end
    end

  end
end
