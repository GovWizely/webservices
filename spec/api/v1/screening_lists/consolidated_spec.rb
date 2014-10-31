require 'spec_helper'

describe 'Consolidated Screening List API V1', type: :request do
  include_context 'all CSL fixture data'
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /consolidated_screening_list/search' do
    let(:params) { { size: 100 } }
    before { get '/consolidated_screening_list/search', params, v1_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'a successful search request'

      it_behaves_like 'it contains all SDN results'
      it_behaves_like 'it contains all FSE results'
      it_behaves_like 'it contains all EL results'
      it_behaves_like 'it contains all DPL results'
      it_behaves_like 'it contains all UVL results'
      it_behaves_like 'it contains all ISN results'
      it_behaves_like 'it contains all DTC results'
      it_behaves_like 'it contains all PLC results'
      it_behaves_like 'it contains all SSI results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { %w(SDN FSE EL DPL UVL ISN DTC PLC SSI) }
      end
    end

    context 'when q is specified' do
      let(:params) { { q: 'cuba' } }

      subject { response }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all SDN results that match "cuba"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { %w(SDN) }
      end

      context 'when search term exists only in name' do
        let(:params) { { q: 'banco' } }
        it_behaves_like 'it contains all SDN results that match "banco"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(SDN) }
        end

        context 'and is in the PLC index' do
          let(:params) { { q: 'heBron' } }
          subject { response }
          it_behaves_like 'a successful search request'
          it_behaves_like 'it contains all PLC results that match "heBron"'
          it_behaves_like 'it contains only results with sources' do
            let(:sources) { %w(PLC) }
          end
        end

        context 'and is in the SSI index' do
          let(:params) { { q: 'transneFT' } }
          subject { response }
          it_behaves_like 'a successful search request'
          it_behaves_like 'it contains all SSI results that match "transneft"'
          it_behaves_like 'it contains only results with sources' do
            let(:sources) { %w(SSI) }
          end
        end
      end

      context 'when search term exists only in alt_names' do
        let(:params) { { q: 'jumali' } }
        it_behaves_like 'it contains all SDN results that match "jumali"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(SDN) }
        end
      end

      context 'when search term exists only in title' do
        let(:params) { { q: 'havana' } }
        it_behaves_like 'it contains all SDN results that match "havana"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(SDN) }
        end
      end

      context 'when search term exists only in remarks' do
        let(:params) { { q: 'djiboutian' } }
        it_behaves_like 'it contains all SDN results that match "djiboutian"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(SDN) }
        end
      end

      context 'when the search term is "technology"' do
        let(:params) { { q: 'technology' } }
        it_behaves_like 'it contains all UVL results that match "technology", sorted correctly'
      end
    end

    context 'when countries is specified' do
      subject { response }

      context 'and one country is searched for' do
        let(:params) { { countries: 'CH' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all SDN results that match countries "CH"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(SDN) }
        end

        context 'which is present in nationalities' do
          let(:params) { { countries: 'DE' } }
          it_behaves_like 'it contains all SDN results that match countries "DE"'
          it_behaves_like 'it contains only results with sources' do
            let(:sources) { %w(SDN DPL) }
          end
        end

        context 'which is present in citizenships' do
          let(:params) { { countries: 'FR' } }
          it_behaves_like 'it contains all SDN results that match countries "FR"'
          it_behaves_like 'it contains all DPL results that match countries "FR"'
          it_behaves_like 'it contains only results with sources' do
            let(:sources) { %w(SDN DPL) }
          end
        end

        context 'which is present in id.country' do
          let(:params) { { countries: 'BE' } }
          it_behaves_like 'it contains all SDN results that match countries "BE"'
          it_behaves_like 'it contains only results with sources' do
            let(:sources) { %w(SDN) }
          end
        end
      end

      context 'two countries searched for' do
        let(:params) { { countries: 'so,jp' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all SDN results that match countries "SO,JP"'
        it_behaves_like 'it contains all FSE results that match countries "SO"'
        it_behaves_like 'it contains all DPL results that match countries "JP"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(SDN FSE DPL) }
        end
      end
    end

    context 'when type is specified' do
      subject { response }

      let(:params) { { type: 'Entity' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all SDN results that match type "Entity"'
      it_behaves_like 'it contains all FSE results that match type "Entity"'
      it_behaves_like 'it contains all SSI results that match type "Entity"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { %w(SDN FSE SSI) }
      end

      context 'and is set to "Vessel"' do
        let(:params) { { type: 'Vessel' } }
        it_behaves_like 'it contains all SDN results that match type "Vessel"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(SDN) }
        end
      end

      context 'and is set to "Individual"' do
        let(:params) { { type: 'Individual' } }
        it_behaves_like 'it contains all SDN results that match type "Individual"'
        it_behaves_like 'it contains all FSE results that match type "Individual"'
        it_behaves_like 'it contains all PLC results that match type "Individual"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(SDN FSE PLC) }
        end
      end
    end

    context 'when source is specified' do
      subject { response }

      let(:params) { { sources: 'SDN' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all SDN results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { %w(SDN) }
      end

      context 'and is set to "FSE" source' do
        let(:params) { { sources: 'FSE' } }
        it_behaves_like 'it contains all FSE results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(FSE) }
        end
      end

      context 'and is set to "EL" source' do
        let(:params) { { sources: 'EL' } }
        it_behaves_like 'it contains all EL results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(EL) }
        end
      end

      context 'and is set to "DPL" source' do
        let(:params) { { sources: 'DPL' } }
        it_behaves_like 'it contains all DPL results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(DPL) }
        end
      end

      context 'and is set to "UVL" source' do
        let(:params) { { sources: 'UVL', size: 100 } }
        it_behaves_like 'it contains all UVL results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(UVL) }
        end
      end

      context 'and is set to "ISN" source' do
        let(:params) { { sources: 'ISN' } }
        it_behaves_like 'it contains all ISN results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(ISN) }
        end
      end

      context 'and is set to "DTC" source' do
        let(:params) { { sources: 'DTC' } }
        it_behaves_like 'it contains all DTC results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(DTC) }
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
end
