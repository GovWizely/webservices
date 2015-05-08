require 'spec_helper'

describe 'BISN Foreign Sanctions Evaders API V1', type: :request do
  include_context 'ScreeningList::Fse data'
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /consolidated_screening_list/fse/search' do
    let(:params) { {} }
    before { get '/consolidated_screening_list/fse/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'it contains all ScreeningList::Fse results'
      it_behaves_like 'a successful search request'
    end

    context 'when q is specified' do
      let(:params) { { q: 'ferland' } }

      subject { response }
      it_behaves_like 'a successful search request'
      let(:source) { ScreeningList::Fse }
      let(:expected) { [0, 2] }
      it_behaves_like 'it contains all expected results of source'

      context 'when search term exists only in name' do
        let(:params) { { q: 'vitaly' } }
        let(:source) { ScreeningList::Fse }
        let(:expected) { [2] }
        it_behaves_like 'it contains all expected results of source'
      end

      context 'when search term exists only in alt_names' do
        let(:params) { { q: 'shahali' } }
        let(:source) { ScreeningList::Fse }
        let(:expected) { [1] }
        it_behaves_like 'it contains all expected results of source'
      end

      context 'when search term exists only in title' do
        let(:params) { { q: 'manager' } }
        let(:source) { ScreeningList::Fse }
        let(:expected) { [2] }
        it_behaves_like 'it contains all expected results of source'
      end

      context 'when search term exists only in remarks' do
        let(:params) { { q: 'tanker' } }
        let(:source) { ScreeningList::Fse }
        let(:expected) { [0] }
        it_behaves_like 'it contains all expected results of source'
      end
    end

    context 'when countries is specified' do
      subject { response }

      context 'and one country is searched for' do
        let(:params) { { countries: 'CY' } }
        it_behaves_like 'a successful search request'
        let(:source) { ScreeningList::Fse }
        let(:expected) { [0] }
        it_behaves_like 'it contains all expected results of source'

        context 'which is present in nationalities' do
          let(:params) { { countries: 'SO' } }
          it_behaves_like 'it contains all ScreeningList::Fse results that match countries "SO"'
        end

        context 'which is present in citizenships' do
          let(:params) { { countries: 'DJ' } }
          let(:source) { ScreeningList::Fse }
          let(:expected) { [1] }
          it_behaves_like 'it contains all expected results of source'
        end

        context 'which is present in id.country' do
          let(:params) { { countries: 'IR' } }
          let(:source) { ScreeningList::Fse }
          let(:expected) { [1] }
          it_behaves_like 'it contains all expected results of source'
        end
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'ua,dj' } }
        it_behaves_like 'a successful search request'
        let(:source) { ScreeningList::Fse }
        let(:expected) { [0, 1] }
        it_behaves_like 'it contains all expected results of source'
      end
    end

    context 'when type is specified' do
      subject { response }
      let(:params) { { type: 'Entity' } }

      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Fse results that match type "Entity"'

      context 'and is set to "Individual"' do
        let(:params) { { type: 'Individual' } }
        it_behaves_like 'it contains all ScreeningList::Fse results that match type "Individual"'
      end
    end
  end
end
