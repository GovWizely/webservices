require 'spec_helper'

describe 'Consolidated Trade Leads API V2', type: :request do
  include_context 'all Trade Leads fixture data'
  let(:v2_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v2' } }

  describe 'GET /trade_leads/search' do
    let(:params) { { size: 100 } }
    before { get '/trade_leads/search', params, v2_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'a successful search request'

      it_behaves_like 'it contains all TradeLead::Australia results'
      it_behaves_like 'it contains all TradeLead::Fbopen results'
      it_behaves_like 'it contains all TradeLead::State results'
      it_behaves_like 'it contains all TradeLead::Uk results'
      it_behaves_like 'it contains all TradeLead::Canada results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [TradeLead::Australia, TradeLead::Fbopen, TradeLead::State,
           TradeLead::Uk, TradeLead::Canada]
        end
      end
    end

    context 'when source is specified' do
      subject { response }

      let(:params) { { sources: 'AUSTRALIA' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeLead::Australia results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeLead::Australia] }
      end
    end

    context 'when source is set to "FBO"' do
      let(:params) { { sources: 'FBO' } }
      it_behaves_like 'it contains all TradeLead::Fbopen results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeLead::Fbopen] }
      end
    end

    context 'and is set to "STATE" source' do
      let(:params) { { sources: 'STATE' } }
      it_behaves_like 'it contains all TradeLead::State results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeLead::State] }
      end
    end

    context 'and is set to "UK" source' do
      let(:params) { { sources: 'UK' } }
      it_behaves_like 'it contains all TradeLead::Uk results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeLead::Uk] }
      end
    end

    context 'and is set to "CANADA" source' do
      let(:params) { { sources: 'CANADA' } }
      it_behaves_like 'it contains all TradeLead::Canada results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeLead::Canada] }
      end

      context 'and searching for field with non ascii characters using ascii characters' do
        let(:params) { {  q: 'Montée', sources: 'CANADA' } }
        it_behaves_like 'it contains all TradeLead::Canada results that match "Montée"'
      end
    end

    context "when search query is set to 'equipment'" do
      let(:params) { { q: 'equipment' } }
      it_behaves_like 'it contains all TradeLead::Australia results that match "equipment"'
      it_behaves_like 'it contains all TradeLead::Fbopen results that match "equipment"'
      it_behaves_like 'it contains all TradeLead::State results that match "equipment"'
      it_behaves_like 'it contains all TradeLead::Uk results that match "equipment"'
      it_behaves_like 'it contains all TradeLead::Canada results that match "equipment"'
    end

    context "when search query is set to 'sanitation'" do
      let(:params) { { q: 'sanitation' } }
      it_behaves_like 'it search among tags of TradeLead::State that match "sanitation"'
    end

    it_behaves_like "an empty result when a query doesn't match any documents"

    context "when search query is set to 'equipment' and source is set to 'AUSTRALIA'" do
      let(:params) { { q: 'equipment', sources: 'AUSTRALIA' } }
      it_behaves_like 'it contains all TradeLead::Australia results that match "equipment"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeLead::Australia] }
      end
    end

    context "when industries is set to 'Medical'" do
      let(:params) { { industries: 'Health Care and Social Assistance,G009E: Medical/Dental Clinic Services' } }
      it_behaves_like 'it contains all TradeLead::Australia results that match industries "Health Care Medical"'
      it_behaves_like 'it contains all TradeLead::Fbopen results that match industries "Health Care Medical"'
      it_behaves_like 'it contains all TradeLead::State results that match industries "Health Care Medical"'
      it_behaves_like 'it contains all TradeLead::Uk results that match industries "Health Care Medical"'
      it_behaves_like 'it contains all TradeLead::Canada results that match industries "Health Care Medical"'
    end
    it_behaves_like "an empty result when an industries search doesn't match any documents"

    context "when contries is set to 'QA'" do
      let(:params) { { countries: 'QA' } }
      it_behaves_like 'it contains all TradeLead::State results that match country "QA"'
    end
    it_behaves_like "an empty result when a countries search doesn't match any documents"

    context "when contries is set to 'CA'" do
      let(:params) { { countries: 'CA' } }
      it_behaves_like 'it contains all TradeLead::Canada results'
    end

  end
end
