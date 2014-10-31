require 'spec_helper'

describe 'BIS Entities API V1', type: :request do
  include_context 'EL data'
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /consolidated_screening_list/el/search' do
    let(:params) { {} }
    before { get '/consolidated_screening_list/el/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all EL results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'fazel' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all EL results that match "fazel"'

      context 'when search term exists only in name' do
        let(:params) { { q: 'constructions' } }
        it_behaves_like 'it contains all EL results that match "constructions"'
      end

      context 'when search term exists only in alt_names' do
        let(:params) { { q: 'farid' } }
        it_behaves_like 'it contains all EL results that match "farid"'
      end
    end

    context 'when countries is specified' do
      subject { response }

      context 'and one country is searched for' do
        let(:params) { { countries: 'AF' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all EL results that match countries "AF"'
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'af,tr' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all EL results that match countries "AF,TR"'
      end
    end

  end
end
