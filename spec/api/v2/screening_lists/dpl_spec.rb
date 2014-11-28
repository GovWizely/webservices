require 'spec_helper'

describe 'BIS Denied Persons API V2', type: :request do
  include_context 'ScreeningList::Dpl data'
  let(:v2_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v2' } }

  describe 'GET /consolidated_screening_list/dpl/search' do
    let(:params) { {} }
    before { get '/consolidated_screening_list/dpl/search', params, v2_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all ScreeningList::Dpl results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'katsuta' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Dpl results that match "katsuta"'

      context 'when search term exists only in name' do
        let(:params) { { q: 'agnese' } }
        it_behaves_like 'it contains all ScreeningList::Dpl results that match "agnese"'
      end

      context 'when search term exists only in remarks' do
        let(:params) { { q: 'corrected' } }
        it_behaves_like 'it contains all ScreeningList::Dpl results that match "corrected"'
      end
    end

    context 'when countries is specified' do
      subject { response }

      context 'and one country is searched for' do
        let(:params) { { countries: 'za' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all ScreeningList::Dpl results that match countries "ZA"'
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'fr,de' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all ScreeningList::Dpl results that match countries "FR,DE"'
      end
    end

  end
end
