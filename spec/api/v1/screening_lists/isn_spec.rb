require 'spec_helper'

describe 'BISN Nonproliferation Sanctions API V1', type: :request do
  include_context 'ScreeningList::Isn data'

  describe 'GET /consolidated_screening_list/isn/search' do
    let(:params) { {} }
    before { get '/consolidated_screening_list/isn/search', params }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all ScreeningList::Isn results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'ahmad' } }

      subject { response }
      it_behaves_like 'a successful search request'
      let(:source) { ScreeningList::Isn }
      let(:expected) { [3, 4] }
      it_behaves_like 'it contains all expected results of source'

      context 'when search term exists only in name' do
        let(:params) { { q: 'aerospace' } }
        let(:source) { ScreeningList::Isn }
        let(:expected) { [1, 2] }
        it_behaves_like 'it contains all expected results of source'
      end
    end
  end
end
