require 'spec_helper'

describe 'BIS Unverified Parties API V2', type: :request do
  include_context 'V2 headers'
  include_context 'ScreeningList::Uvl data'

  describe 'GET /consolidated_screening_list/uvl/search' do
    let(:params) { { size: 100 } }
    before { get '/consolidated_screening_list/uvl/search', params, @v2_headers }

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
        it_behaves_like 'it contains all ScreeningList::Uvl results that match "brilliance"'
      end
    end

    context 'when countries is specified' do
      subject { response }

      context 'and one country is searched for' do
        let(:params) { { countries: 'CN' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all ScreeningList::Uvl results that match countries "CN"'
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'hk,cn' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all ScreeningList::Uvl results that match countries "HK,CN"'
      end
    end

  end
end
