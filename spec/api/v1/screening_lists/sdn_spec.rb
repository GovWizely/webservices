require 'spec_helper'

describe 'OFAC Specially Designated Nationals API V1', type: :request do
  include_context 'ScreeningList::Sdn data'
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /consolidated_screening_list/sdn/search' do
    let(:params) { {} }
    before { get '/consolidated_screening_list/sdn/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all ScreeningList::Sdn results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'cuba' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Sdn results that match "cuba"'

      context 'when search term exists only in name' do
        let(:params) { { q: 'banco' } }
        it_behaves_like 'it contains all ScreeningList::Sdn results that match "banco nacional de cuba"'
      end

      context 'when search term exists only in alt_names' do
        let(:params) { { q: 'jumali' } }
        it_behaves_like 'it contains all ScreeningList::Sdn results that match "jumali"'
      end

      context 'when search term exists only in title' do
        let(:params) { { q: 'havana' } }
        it_behaves_like 'it contains all ScreeningList::Sdn results that match "havana"'
      end

      context 'when search term exists only in remarks' do
        let(:params) { { q: 'djiboutian' } }
        it_behaves_like 'it contains all ScreeningList::Sdn results that match "djiboutian"'
      end
    end

    context 'when countries is specified' do
      subject { response }

      context 'and one country is searched for' do
        let(:params) { { countries: 'CH' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all ScreeningList::Sdn results that match countries "CH"'

        context 'which is present in nationalities' do
          let(:params) { { countries: 'DE' } }
          it_behaves_like 'it contains all ScreeningList::Sdn results that match countries "DE"'
        end

        context 'which is present in citizenships' do
          let(:params) { { countries: 'FR' } }
          it_behaves_like 'it contains all ScreeningList::Sdn results that match countries "FR"'
        end

        context 'which is present in id.country' do
          let(:params) { { countries: 'BE' } }
          it_behaves_like 'it contains all ScreeningList::Sdn results that match countries "BE"'
        end
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'so,jp' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all ScreeningList::Sdn results that match countries "SO,JP"'
      end
    end

    context 'when type is specified' do
      subject { response }

      let(:params) { { type: 'Entity' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Sdn results that match type "Entity"'

      context 'and is set to "Vessel"' do
        let(:params) { { type: 'vEssEl' } }
        it_behaves_like 'it contains all ScreeningList::Sdn results that match type "Vessel"'
      end

      context 'and is set to "Individual"' do
        let(:params) { { type: 'individual' } }
        it_behaves_like 'it contains all ScreeningList::Sdn results that match type "Individual"'
      end
    end

  end
end
