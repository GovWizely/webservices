require 'spec_helper'

describe 'Palestinian Legislative Council List API V1' do
  include_context 'PLC data'
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /consolidated_screening_list/plc/search' do
    let(:params) { {} }
    before { get '/consolidated_screening_list/plc/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all PLC results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'heBron' } }
      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all PLC results that match "heBron"'
    end

    context 'when countries is specified' do
      subject { response }
      let(:params) { { countries: 'PS' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all PLC results that match countries "PS"'
    end

    context 'when type is specified' do
      subject { response }
      let(:params) { { nsp_type: 'Individual' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all PLC results that match type "Individual"'
    end
  end
end
