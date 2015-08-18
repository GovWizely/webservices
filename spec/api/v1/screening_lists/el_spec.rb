require 'spec_helper'

describe 'BIS Entities API V1', type: :request do
  include_context 'ScreeningList::El data'

  describe 'GET /v1/consolidated_screening_list/el/search' do
    let(:params) { {} }
    before { get '/v1/consolidated_screening_list/el/search', params }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all ScreeningList::El results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'fazel' } }

      subject { response }
      it_behaves_like 'a successful search request'
      let(:source) { ScreeningList::El }
      let(:expected) { [0, 1] }
      it_behaves_like 'it contains all expected results of source'

      context 'when search term exists only in name' do
        let(:params) { { q: 'construction' } }
        let(:source) { ScreeningList::El }
        let(:expected) { [1, 6] }
        it_behaves_like 'it contains all expected results of source'
      end

      context 'when search term exists only in alt_names' do
        let(:params) { { q: 'farid' } }
        let(:source) { ScreeningList::El }
        let(:expected) { [0] }
        it_behaves_like 'it contains all expected results of source'
      end
    end

    context 'when countries is specified' do
      subject { response }

      context 'and one country is searched for' do
        let(:params) { { countries: 'AF' } }
        it_behaves_like 'a successful search request'
        let(:source) { ScreeningList::El }
        let(:expected) { [0, 1, 3, 4, 5, 6] }
        it_behaves_like 'it contains all expected results of source'
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'af,tr' } }
        it_behaves_like 'a successful search request'
        let(:source) { ScreeningList::El }
        let(:expected) { [0, 1, 2, 3, 4, 5, 6] }
        it_behaves_like 'it contains all expected results of source'
      end
    end
  end
end
