require 'spec_helper'

describe 'BISN Foreign Sanctions Evaders API V1' do
  include_context 'FSE data'
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /foreign_sanctions_evaders_list/search' do
    let(:params) { {} }
    before { get '/foreign_sanctions_evaders_list/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all FSE results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'ferland' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all FSE results that match "ferland"'

      context 'when search term exists only in name' do
        let(:params) { { q: 'vitaly' } }
        it_behaves_like 'it contains all FSE results that match "vitaly"'
      end

      context 'when search term exists only in alt_names' do
        let(:params) { { q: 'shahali' } }
        it_behaves_like 'it contains all FSE results that match "shahali"'
      end

      context 'when search term exists only in title' do
        let(:params) { { q: 'manager' } }
        it_behaves_like 'it contains all FSE results that match "manager"'
      end

      context 'when search term exists only in remarks' do
        let(:params) { { q: 'tanker' } }
        it_behaves_like 'it contains all FSE results that match "tanker"'
      end
    end

    context 'when countries is specified' do
      subject { response }

      context 'and one country is searched for' do
        let(:params) { { countries: 'CY' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all FSE results that match countries "CY"'


        context 'which is present in nationalities' do
          let(:params) { { countries: 'SO' } }
          it_behaves_like 'it contains all FSE results that match countries "SO"'
        end

        context 'which is present in citizenships' do
          let(:params) { { countries: 'DJ' } }
          it_behaves_like 'it contains all FSE results that match countries "DJ"'
        end

        context 'which is present in id.country' do
          let(:params) { { countries: 'IR' } }
          it_behaves_like 'it contains all FSE results that match countries "IR"'
        end
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'ua,dj' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all FSE results that match countries "UA,DJ"'
      end
    end

    context 'when sdn_type is specified' do
      subject { response }
      let(:params) { { sdn_type: 'Entity' } }

      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all FSE results that match sdn_type "Entity"'


      context 'and is set to "Individual"' do
        let(:params) { { sdn_type: 'Individual' } }
        it_behaves_like 'it contains all FSE results that match sdn_type "Individual"'
      end
    end

  end
end
