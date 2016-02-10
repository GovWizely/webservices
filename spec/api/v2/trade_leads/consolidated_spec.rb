require 'spec_helper'

describe 'Consolidated Trade Leads API V2', type: :request do
  include_context 'V2 headers'
  include_context 'all Trade Leads fixture data'

  describe 'GET /trade_leads/search' do
    let(:params) { { size: 100 } }
    let(:aggregation_mappings) do
      { industries: :industry, countries: :country, sources: :source }
    end

    before { get 'v2/trade_leads/search', params, @v2_headers }

    context 'when search parameters are empty' do
      subject { response }
      it_behaves_like 'a successful search request'

      it_behaves_like 'it contains all TradeLead::Australia results'
      it_behaves_like 'it contains all TradeLead::Fbopen results'
      it_behaves_like 'it contains all TradeLead::State results'
      it_behaves_like 'it contains all TradeLead::Uk results'
      it_behaves_like 'it contains all TradeLead::Canada results'
      it_behaves_like 'it contains all TradeLead::Ustda results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [TradeLead::Australia, TradeLead::Fbopen, TradeLead::State,
           TradeLead::Uk, TradeLead::Canada, TradeLead::Mca, TradeLead::Ustda]
        end
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/all_sources/aggregations.json' }
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
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/australia/aggregations.json' }
      end
    end

    context 'when source is set to "FBO"' do
      let(:params) { { sources: 'FBO' } }
      it_behaves_like 'it contains all TradeLead::Fbopen results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeLead::Fbopen] }
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/fbopen/aggregations.json' }
      end
    end

    context 'and is set to "STATE" source' do
      let(:params) { { sources: 'STATE' } }
      it_behaves_like 'it contains all TradeLead::State results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeLead::State] }
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/state/aggregations.json' }
      end
    end

    context 'and is set to "UK" source' do
      let(:params) { { sources: 'UK' } }
      it_behaves_like 'it contains all TradeLead::Uk results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeLead::Uk] }
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/uk/aggregations.json' }
      end
    end

    context 'and is set to "MCA" source' do
      let(:params) { { sources: 'MCA' } }
      let(:expected) { [0, 1, 2] }
      it_behaves_like 'it contains all TradeLead::Mca results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeLead::Mca] }
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/mca/aggregations.json' }
      end
    end

    context 'and is set to "USTDA" source' do
      let(:params) { { sources: 'USTDA' } }
      it_behaves_like 'it contains all TradeLead::Ustda results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeLead::Ustda] }
      end
    end

    context 'and is set to "CANADA" source' do
      let(:params) { { sources: 'CANADA' } }
      it_behaves_like 'it contains all TradeLead::Canada results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeLead::Canada] }
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/canada/aggregations.json' }
      end

      context 'and searching for field with non ascii characters using ascii characters' do
        let(:params) { {  q: 'Montée', sources: 'CANADA' } }
        it_behaves_like 'it contains all TradeLead::Canada results that match "Montée"'
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'trade_leads/canada/aggregations_with_query_montee.json' }
        end
      end
    end

    context "when search query is set to 'equipment'" do
      let(:params) { { q: 'equipment' } }
      it_behaves_like 'it contains all TradeLead::Australia results that match "equipment"'
      it_behaves_like 'it contains all TradeLead::Fbopen results that match "equipment"'
      it_behaves_like 'it contains all TradeLead::State results that match "equipment"'
      it_behaves_like 'it contains all TradeLead::Uk results that match "equipment"'
      it_behaves_like 'it contains all TradeLead::Canada results that match "equipment"'
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/all_sources/aggregations_with_query_equipment.json' }
      end
      it_behaves_like 'it contains all TradeLead::Ustda results that match "equipment"'
    end

    context "when search query is set to 'sanitation'" do
      let(:params) { { q: 'sanitation' } }
      it_behaves_like 'it search among tags of TradeLead::State that match "sanitation"'
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/state/aggregations_with_query_sanitation.json' }
      end
    end

    it_behaves_like "an empty result when a query doesn't match any documents"

    context "when search query is set to 'equipment' and source is set to 'AUSTRALIA'" do
      let(:params) { { q: 'equipment', sources: 'AUSTRALIA' } }
      it_behaves_like 'it contains all TradeLead::Australia results that match "equipment"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeLead::Australia] }
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/australia/aggregations_with_query_equipment.json' }
      end
    end

    context "when industries is set to 'Medical'" do
      let(:params) { { industries: 'Health Care and Social Assistance,G009E: Medical/Dental Clinic Services' } }
      it_behaves_like 'it contains all TradeLead::Australia results that match industries "Health Care Medical"'
      it_behaves_like 'it contains all TradeLead::Fbopen results that match industries "Health Care Medical"'
      it_behaves_like 'it contains all TradeLead::State results that match industries "Health Care Medical"'
      it_behaves_like 'it contains all TradeLead::Canada results that match industries "Health Care Medical"'
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/all_sources/aggregations_with_query_health_care_medical.json' }
      end
    end
    it_behaves_like "an empty result when an industries search doesn't match any documents"

    context "when contries is set to 'QA'" do
      let(:params) { { countries: 'QA' } }
      it_behaves_like 'it contains all TradeLead::State results that match country "QA"'
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/state/aggregations_with_countries_qa.json' }
      end
    end
    it_behaves_like "an empty result when a countries search doesn't match any documents"

    context "when contries is set to 'CA'" do
      let(:params) { { countries: 'CA' } }
      it_behaves_like 'it contains all TradeLead::Canada results'
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/canada/aggregations.json' }
      end
    end

    context 'when publish_date_amended_start or publish_date_amended_end is specified' do
      subject { response }
      let(:params) { { sources: 'Australia', publish_date_amended: '2013-01-04 TO 2013-01-04' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeLead::Australia results where publish_date_amended is 2013-01-04'
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/australia/aggregations_with_published_date_amended_2013-01-04.json' }
      end
    end

    context 'when publish_date_start or publish_date_end is specified' do
      subject { response }
      let(:params) { { sources: 'Canada', publish_date: '2014-03-20 TO 2014-03-20' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeLead::Canada results where publish_date is 2014-03-20'
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/canada/aggregations_with_published_date_2014-03-20.json' }
      end
    end

    context 'when end_date_start or end_date_end is specified' do
      subject { response }
      let(:params) { { sources: 'State', end_date: '2014-03-06 TO 2014-03-06' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeLead::State results where end_date is 2014-03-06'
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_leads/state/aggregations_with_end_date_2014-03-06.json' }
      end
    end

    context 'when trade_regions is specified' do
      subject { response }
      let(:params) { { sources: 'Ustda', trade_regions: 'African Growth and Opportunity Act' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeLead::Ustda results where trade_regions is "African Growth and Opportunity Act"'
    end

    context 'when world_regions is specified' do
      subject { response }
      let(:params) { { sources: 'Ustda', world_regions: 'Africa, Central America' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeLead::Ustda results where world_regions is "Africa, Central America"'
    end
  end
end
