require 'spec_helper'

describe 'Consolidated Screening List API V1', type: :request do
  include_context 'all CSL fixture data'
  include_context 'exclude id from all possible full results'

  describe 'GET /v1/consolidated_screening_list/search' do
    let(:params) { { size: 100 } }
    before { get '/v1/consolidated_screening_list/search', params }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'a successful search request'

      it_behaves_like 'it contains all ScreeningList::Sdn results'
      it_behaves_like 'it contains all ScreeningList::Fse results'
      it_behaves_like 'it contains all ScreeningList::El results'
      it_behaves_like 'it contains all ScreeningList::Dpl results'
      it_behaves_like 'it contains all ScreeningList::Uvl results'
      it_behaves_like 'it contains all ScreeningList::Isa results'
      it_behaves_like 'it contains all ScreeningList::Isn results'
      it_behaves_like 'it contains all ScreeningList::Dtc results'
      it_behaves_like 'it contains all ScreeningList::Part561 results'
      it_behaves_like 'it contains all ScreeningList::Plc results'
      it_behaves_like 'it contains all ScreeningList::Ssi results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [ScreeningList::Sdn, ScreeningList::Fse, ScreeningList::El,
           ScreeningList::Dpl, ScreeningList::Uvl, ScreeningList::Isa, ScreeningList::Isn,
           ScreeningList::Dtc, ScreeningList::Part561, ScreeningList::Plc, ScreeningList::Ssi]
        end
      end
    end

    context 'when name is specified' do
      let(:params) { { name: 'banco nacional de cuba' } }
      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Sdn results that match "banco nacional de cuba"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [ScreeningList::Sdn] }
      end

      context 'and distance is specified' do
        let(:params) { { name: 'SALEH Jamal', distance: '1' } }
        subject { response }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all ScreeningList::Plc results that match "SALEH, Jamal" with distance of 1'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Plc] }
        end
      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'cuba' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Sdn results that match "cuba"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [ScreeningList::Sdn] }
      end

      context 'when search term exists only in name' do
        let(:params) { { q: 'banco' } }
        it_behaves_like 'it contains all ScreeningList::Sdn results that match "banco nacional de cuba"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Sdn] }
        end

        context 'and is in the ScreeningList::Plc index' do
          let(:params) { { q: 'heBron' } }
          subject { response }
          it_behaves_like 'a successful search request'
          it_behaves_like 'it contains all ScreeningList::Plc results that match "heBron"'
          it_behaves_like 'it contains only results with sources' do
            let(:sources) { [ScreeningList::Plc] }
          end
        end

        context 'and is in the ScreeningList::Ssi index' do
          let(:params) { { q: 'transneFT' } }
          subject { response }
          it_behaves_like 'a successful search request'
          it_behaves_like 'it contains all ScreeningList::Ssi results that match "transneft"'
          it_behaves_like 'it contains only results with sources' do
            let(:sources) { [ScreeningList::Ssi] }
          end
        end
      end

      context 'when search term exists only in alt_names' do
        let(:params) { { q: 'jumali' } }
        it_behaves_like 'it contains all ScreeningList::Sdn results that match "jumali"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Sdn] }
        end
      end

      context 'when search term exists only in title' do
        let(:params) { { q: 'havana' } }
        it_behaves_like 'it contains all ScreeningList::Sdn results that match "havana"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Sdn] }
        end
      end

      context 'when search term exists only in remarks' do
        let(:params) { { q: 'djiboutian' } }
        it_behaves_like 'it contains all ScreeningList::Sdn results that match "djiboutian"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Sdn] }
        end
      end

      context 'when the search term is "technology"' do
        let(:params) { { q: 'technology' } }
        it_behaves_like 'it contains all ScreeningList::Uvl results that match "technology", sorted correctly'
      end

      it_behaves_like "an empty result when a query doesn't match any documents"
    end

    context 'when countries is specified' do
      subject { response }

      context 'and one country is searched for' do
        let(:params) { { countries: 'CH' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all ScreeningList::Sdn results that match countries "CH"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Sdn] }
        end

        context 'which is present in nationalities' do
          let(:params) { { countries: 'DE' } }
          it_behaves_like 'it contains all ScreeningList::Sdn results that match countries "DE"'
          it_behaves_like 'it contains only results with sources' do
            let(:sources) { [ScreeningList::Sdn, ScreeningList::Dpl] }
          end
        end

        context 'which is present in citizenships' do
          let(:params) { { countries: 'FR' } }
          it_behaves_like 'it contains all ScreeningList::Sdn results that match countries "FR"'
          it_behaves_like 'it contains all ScreeningList::Dpl results that match countries "FR"'
          it_behaves_like 'it contains only results with sources' do
            let(:sources) { [ScreeningList::Sdn, ScreeningList::Dpl] }
          end
        end

        context 'which is present in id.country' do
          let(:params) { { countries: 'BE' } }
          it_behaves_like 'it contains all ScreeningList::Sdn results that match countries "BE"'
          it_behaves_like 'it contains only results with sources' do
            let(:sources) { [ScreeningList::Sdn] }
          end
        end
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'so,jp' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all ScreeningList::Sdn results that match countries "SO,JP"'
        it_behaves_like 'it contains all ScreeningList::Fse results that match countries "SO"'
        it_behaves_like 'it contains all ScreeningList::Dpl results that match countries "JP"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Sdn, ScreeningList::Fse, ScreeningList::Dpl] }
        end
      end
      it_behaves_like "an empty result when a countries search doesn't match any documents"
    end

    context 'when type is specified' do
      subject { response }

      let(:params) { { type: 'Entity' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Sdn results that match type "Entity"'
      it_behaves_like 'it contains all ScreeningList::Fse results that match type "Entity"'
      it_behaves_like 'it contains all ScreeningList::Ssi results that match type "Entity"'
      it_behaves_like 'it contains all ScreeningList::Isa results that match type "Entity"'
      it_behaves_like 'it contains all ScreeningList::Part561 results that match type "Entity"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [ScreeningList::Sdn, ScreeningList::Fse, ScreeningList::Ssi, ScreeningList::Isa, ScreeningList::Part561] }
      end

      context 'and is set to "Vessel"' do
        let(:params) { { type: 'Vessel' } }
        it_behaves_like 'it contains all ScreeningList::Sdn results that match type "Vessel"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Sdn] }
        end
      end

      context 'and is set to "Individual"' do
        let(:params) { { type: 'Individual' } }
        it_behaves_like 'it contains all ScreeningList::Sdn results that match type "Individual"'
        it_behaves_like 'it contains all ScreeningList::Fse results that match type "Individual"'
        it_behaves_like 'it contains all ScreeningList::Plc results that match type "Individual"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Sdn, ScreeningList::Fse, ScreeningList::Plc] }
        end
      end
    end

    context 'when source is specified' do
      subject { response }

      let(:params) { { sources: 'SDN' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Sdn results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [ScreeningList::Sdn] }
      end

      context 'and is set to "FSE" source' do
        let(:params) { { sources: 'FSE' } }
        it_behaves_like 'it contains all ScreeningList::Fse results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Fse] }
        end
      end

      context 'and is set to "EL" source' do
        let(:params) { { sources: 'EL' } }
        it_behaves_like 'it contains all ScreeningList::El results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::El] }
        end
      end

      context 'and is set to "DPL" source' do
        let(:params) { { sources: 'DPL' } }
        it_behaves_like 'it contains all ScreeningList::Dpl results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Dpl] }
        end
      end

      context 'and is set to "UVL" source' do
        let(:params) { { sources: 'UVL', size: 100 } }
        it_behaves_like 'it contains all ScreeningList::Uvl results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Uvl] }
        end
      end

      context 'and is set to "ISN" source' do
        let(:params) { { sources: 'ISN' } }
        it_behaves_like 'it contains all ScreeningList::Isn results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Isn] }
        end
      end

      context 'and is set to "DTC" source' do
        let(:params) { { sources: 'DTC' } }
        it_behaves_like 'it contains all ScreeningList::Dtc results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Dtc] }
        end
      end

      context 'and is set to an unknown source' do
        let(:params) { { sources: 'NSD' } }
        it 'returns no documents' do
          json_response = JSON.parse(response.body)
          expect(json_response['total']).to eq(0)
        end
      end
    end
  end
  describe 'GET /v1/consolidated_screening_list/search.csv' do
    before { get '/v1/consolidated_screening_list/search.csv' }
    it 'is a CSV' do
      expect(response.status).to eq(200)
      expect(response.content_type.symbol).to eq(:csv)
    end
  end
end
