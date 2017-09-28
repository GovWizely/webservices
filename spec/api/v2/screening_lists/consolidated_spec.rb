require 'spec_helper'

describe 'Consolidated Screening List API V2', type: :request do
  include_context 'all CSL fixture data'
  include_context 'V2 headers'

  describe 'GET /consolidated_screening_list/search' do
    let(:params) { { size: -1 } }
    before { get '/v2/consolidated_screening_list/search', params, @v2_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'a successful search request'

      it_behaves_like 'it contains all ScreeningList::Sdn results'
      it_behaves_like 'it contains all ScreeningList::Fse results'
      it_behaves_like 'it contains all ScreeningList::El results'
      it_behaves_like 'it contains all ScreeningList::Eo13599 results'
      it_behaves_like 'it contains all ScreeningList::Dpl results'
      it_behaves_like 'it contains all ScreeningList::Uvl results'
      it_behaves_like 'it contains all ScreeningList::Isn results'
      it_behaves_like 'it contains all ScreeningList::Dtc results'
      it_behaves_like 'it contains all ScreeningList::Part561 results'
      it_behaves_like 'it contains all ScreeningList::Plc results'
      it_behaves_like 'it contains all ScreeningList::Ssi results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [ScreeningList::Sdn, ScreeningList::Fse, ScreeningList::El, ScreeningList::Eo13599,
           ScreeningList::Dpl, ScreeningList::Uvl, ScreeningList::Isn,
           ScreeningList::Dtc, ScreeningList::Part561, ScreeningList::Plc, ScreeningList::Ssi,]
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
    end

    context 'when address is specified' do
      shared_examples 'it contains all ScreeningList::Dpl results with address "MINATOKU"' do
        let(:source) { ScreeningList::Dpl }
        let(:expected) { [6] }
        it_behaves_like 'it contains all expected results of source'
      end

      context 'by address' do
        let(:params) { { address: 'miNATOKU' } }
        subject { response }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all ScreeningList::Dpl results with address "MINATOKU"'
      end
      context 'by country' do
        let(:params) { { address: 'jp' } }
        subject { response }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all ScreeningList::Dpl results with address "MINATOKU"'
      end
      context 'by city' do
        let(:params) { { address: 'tokyo' } }
        subject { response }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all ScreeningList::Dpl results with address "MINATOKU"'
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

        context 'which is present in country' do
          let(:params) { { countries: 'PK' } }
          it_behaves_like 'it contains all ScreeningList::Isn results that match countries "PK"'
          it_behaves_like 'it contains only results with sources' do
            let(:sources) { [ScreeningList::Isn] }
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
      it_behaves_like 'it contains all ScreeningList::Eo13599 results that match type "Entity"'
      it_behaves_like 'it contains all ScreeningList::Part561 results that match type "Entity"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [ScreeningList::Sdn, ScreeningList::Fse, ScreeningList::Ssi, ScreeningList::Eo13599, ScreeningList::Part561] }
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
      it_behaves_like 'it contains all ScreeningList::Sdn results sorted by default'

      context 'and is set to "Part561" source' do
        let(:params) { { sources: '561' } }
        it_behaves_like 'it contains all ScreeningList::Part561 results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Part561] }
        end
      end

      context 'and is set to "Eo13599" source' do
        let(:params) { { sources: '13599' } }
        it_behaves_like 'it contains all ScreeningList::Eo13599 results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [ScreeningList::Eo13599] }
        end
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

    context 'when expiration_date is specified' do
      subject { response }
      let(:params) { { sources: 'SDN', expiration_date: '2010-01-01 TO 2011-01-23' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Sdn results that match expiration_date "2010-01-01 TO 2011-01-23"'
    end

    context 'when issue_date is specified' do
      subject { response }
      let(:params) { { sources: 'SDN', issue_date: '2001-12-25 TO 2002-12-31' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Sdn results that match issue_date "2001-12-25 TO 2002-12-31"'
    end

    context 'when start_date is specified' do
      subject { response }
      let(:params) { { sources: 'EL', start_date: '2011-11-21 TO 2011-11-21' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::El results that match start_date "2011-11-21"'
    end

    context 'when end_date is specified' do
      subject { response }
      let(:params) { { sources: 'DPL', end_date: '2005-06-05 TO 2005-06-05' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all ScreeningList::Dpl results that match end_date "2005-06-05"'
    end

    context 'when sort is specified' do
      context 'and is set to name' do
        include_context 'ScreeningList::Sdn data'
        let(:params) { { sources: 'SDN', sort: 'name:desc' } }
        it 'sorts the results correctly' do
          results = JSON.parse(response.body)['results']
          expect(results).to eq(@all_possible_full_results[ScreeningList::Sdn].reverse)
        end
      end

      context 'and is set to start_date:desc' do
        include_context 'ScreeningList::Isn data'
        let(:params) { { sources: 'ISN', sort: 'start_date:desc' } }
        it 'sorts the results correctly' do
          results = JSON.parse(response.body)['results']
          expect(results).to eq(@all_possible_full_results[ScreeningList::Isn])
        end
      end

      context 'and is set to a non-sortable field' do
        include_context 'ScreeningList::Sdn data'
        let(:params) { { sources: 'SDN', sort: 'address' } }
        it_behaves_like 'it contains all ScreeningList::Sdn results sorted by default'
      end
    end
  end

  context 'requesting a static file' do
    before(:all) do
      class ResponseDummy
        def initialize
        end

        def body
          StringIO.new('foo')
        end

        def last_modified
          DateTime.parse('2017-01-28')
        end
      end
    end

    describe 'GET /consolidated_screening_list/search.csv' do
      before do
        allow(StaticFileManager).to receive(:download_file).and_return(ResponseDummy.new)
        get '/v2/consolidated_screening_list/search.csv', {}, @v2_headers
      end
      it 'is a CSV' do
        expect(response.status).to eq(200)
        expect(response.content_type.symbol).to eq(:csv)
        expect(response.header['Content-Disposition']).to eq('attachment; filename=screening_list/consolidated_2017-01-28.csv')
      end
    end

    describe 'GET /consolidated_screening_list/search.tsv' do
      before do
        allow(StaticFileManager).to receive(:download_file).and_return(ResponseDummy.new)
        get '/v2/consolidated_screening_list/search.tsv', {}, @v2_headers
      end
      it 'is a TSV' do
        expect(response.status).to eq(200)
        expect(response.content_type.symbol).to eq(:tsv)
        expect(response.header['Content-Disposition']).to eq('attachment; filename=screening_list/consolidated_2017-01-28.tsv')
      end
    end
  end

  context 'when countries is specified' do
    let(:params) do
      {
        countries: 'DE',
      }
    end

    before { get '/v2/consolidated_screening_list/search', params, @v2_headers }
    subject { response }
    it_behaves_like 'a successful search request'

    it 'returns only matching response' do
      results = JSON.parse(subject.body)['results']
      expect(results.count).to eq(2)
    end
  end

  context 'when countries and address are specified' do
    let(:params) do
      {
        countries: 'DE',
        address:   'lane',
      }
    end

    before { get '/v2/consolidated_screening_list/search', params, @v2_headers }
    subject { response }
    it_behaves_like 'a successful search request'

    it 'returns only matching response' do
      results = JSON.parse(subject.body)['results']
      expect(results.count).to eq(1)
      expect(results.first['addresses'].first['address']).to eq('20 Ironmonger Lane')
    end
  end

  context 'when fuzzy_name=true and countries are specified' do
    let(:params) do
      {
        name:       'abd',
        fuzzy_name: 'true',
        countries:  'DE',
      }
    end

    before { get '/v2/consolidated_screening_list/search', params, @v2_headers }
    subject { response }
    it_behaves_like 'a successful search request'

    it 'returns only matching response' do
      results = JSON.parse(subject.body)['results']
      expect(results.count).to eq(1)
      expect(results.first['name']).to eq('ADT ANALOG AND DIGITAL TECHNIK')
    end
  end

  context 'when name is multi word string and fuzzy_name=true' do
    let(:params) do
      {
        name:       'qazi abdallha',
        fuzzy_name: 'true',
      }
    end

    before { get '/v2/consolidated_screening_list/search', params, @v2_headers }
    subject { response }
    it_behaves_like 'a successful search request'

    it 'returns only matching response' do
      results = JSON.parse(subject.body)['results']
      expect(results.count).to eq(3)
      names = results.map { |r| r['name'] }.uniq
      expect(names).to eq(['Qazi Abdallah'])
    end
  end
end
