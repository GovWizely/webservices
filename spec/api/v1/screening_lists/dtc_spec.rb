require 'spec_helper'

describe 'DDTC ITAR Debarred Parties API V1', type: :request do
  include_context 'ScreeningList::Dtc data'

  describe 'GET /consolidated_screening_list/dtc/search' do
    let(:params) { {} }
    before { get '/consolidated_screening_list/dtc/search', params }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all ScreeningList::Dtc results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'brian' } }

      subject { response }
      it_behaves_like 'a successful search request'
      let(:source) { ScreeningList::Dtc }
      let(:expected) { [0, 2] }
      it_behaves_like 'it contains all expected results of source'

      context 'when search term exists only in name' do
        let(:params) { { q: 'john' } }
        let(:source) { ScreeningList::Dtc }
        let(:expected) { [2] }
        it_behaves_like 'it contains all expected results of source'
      end

      context 'when search term exists only in alt_names' do
        let(:params) { { q: 'mcsulla' } }
        let(:source) { ScreeningList::Dtc }
        let(:expected) { [0] }
        it_behaves_like 'it contains all expected results of source'
      end
    end
  end
end
