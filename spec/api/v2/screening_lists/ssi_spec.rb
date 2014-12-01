require 'spec_helper'

describe 'Sectoral Sanctions Identifications List API V2', type: :request do
  include_context 'ScreeningList::Ssi data'
  let(:v2_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v2' } }

  describe 'GET /consolidated_screening_list/ssi/search' do
    let(:params) { {} }
    before { get '/consolidated_screening_list/ssi/search', params, v2_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all ScreeningList::Ssi results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'transneft' } }
      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Ssi results that match "transneft"'
    end

    context 'when countries is specified' do
      subject { response }
      context 'and one country is searched for' do
        let(:params) { { countries: 'RU' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all ScreeningList::Ssi results that match countries "RU"'
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'ua,dj' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all ScreeningList::Ssi results that match countries "UA,DJ"'
      end
    end

    context 'when type is specified' do
      subject { response }
      let(:params) { { type: 'Entity' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Ssi results that match type "Entity"'
    end
  end
end
