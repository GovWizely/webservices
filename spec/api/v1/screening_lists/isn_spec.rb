require 'spec_helper'

describe 'BISN Nonproliferation Sanctions API V1' do
  include_context 'ISN data'
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /consolidated_screening_list/isn/search' do
    let(:params) { {} }
    before { get '/consolidated_screening_list/isn/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all ISN results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'ahmad' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ISN results that match "ahmad"'

      context 'when search term exists only in name' do
        let(:params) { { q: 'aerospace' } }
        it_behaves_like 'it contains all ISN results that match "aerospace"'
      end
    end

  end
end
