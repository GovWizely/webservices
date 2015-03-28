require 'spec_helper'

describe 'BIS Denied Persons API V1', type: :request do
  include_context 'ScreeningList::Dpl data'
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /consolidated_screening_list/dpl/search' do
    let(:params) { {} }
    before { get '/consolidated_screening_list/dpl/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all ScreeningList::Dpl results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'katsuta' } }

      subject { response }
      it_behaves_like 'a successful search request'

      let(:source) { ScreeningList::Dpl }
      let(:expected) { [6] }
      it_behaves_like 'it contains all expected results of source'

      context 'when search term exists only in name' do
        let(:params) { { q: 'agnese' } }
        let(:source) { ScreeningList::Dpl }
        let(:expected) { [4] }
        it_behaves_like 'it contains all expected results of source'
      end

      context 'when search term exists only in remarks' do
        let(:params) { { q: 'corrected' } }
        let(:source) { ScreeningList::Dpl }
        let(:expected) { [5, 7] }
        it_behaves_like 'it contains all expected results of source'
      end
    end

    context 'when countries is specified' do
      subject { response }

      context 'and one country is searched for' do
        let(:params) { { countries: 'za' } }
        it_behaves_like 'a successful search request'
        let(:source) { ScreeningList::Dpl }
        let(:expected) { [2] }
        it_behaves_like 'it contains all expected results of source'
        it_behaves_like "an empty result when a countries search doesn't match any documents"
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'fr,de' } }
        it_behaves_like 'a successful search request'
        let(:source) { ScreeningList::Dpl }
        let(:expected) { [3, 4] }
        it_behaves_like 'it contains all expected results of source'
      end
    end

  end
end
