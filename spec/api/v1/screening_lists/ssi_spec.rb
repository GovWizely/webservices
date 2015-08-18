require 'spec_helper'

describe 'Sectoral Sanctions Identifications List API V1', type: :request do
  include_context 'ScreeningList::Ssi data'

  describe 'GET /v1/consolidated_screening_list/ssi/search' do
    let(:params) { {} }
    before { get '/v1/consolidated_screening_list/ssi/search', params }

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
        let(:source) { ScreeningList::Ssi }
        let(:expected) { (0..3).to_a }
        it_behaves_like 'it contains all expected results of source'
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'ua,dj' } }
        it_behaves_like 'a successful search request'
        let(:source) { ScreeningList::Ssi }
        let(:expected) { [] }
        it_behaves_like 'it contains all expected results of source'
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
