require 'spec_helper'

describe 'NS-ISA List API V2', type: :request do
  include_context 'ScreeningList::Isa data'
  let(:v2_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v2' } }

  describe 'GET /consolidated_screening_list/search?sources=ISA' do
    let(:params) { { sources: 'isa' } }
    before { get '/consolidated_screening_list/search', params, v2_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all ScreeningList::Isa results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { sources: 'isa', q: 'kuo' } }
      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Isa results that match "kuo"'
    end

    context 'when countries is specified' do
      let(:params) { { sources: 'isa', countries: 'AE' } }
      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Isa results that match countries "AE"'
    end

    context 'when type is specified' do
      subject { response }
      let(:params) { { sources: 'isa', type: 'Entity' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Isa results that match type "Entity"'
    end
  end
end
