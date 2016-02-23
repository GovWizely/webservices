require 'spec_helper'

describe 'Consolidated Trade Events API V2', type: :request do
  include_context 'V2 headers'
  include_context 'all Trade Events v2 fixture data'

  describe 'GET /trade_events/search' do
    let(:params) { { size: 100 } }
    before { get '/v2/trade_events/search', params, @v2_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results'
      it_behaves_like 'it contains all TradeEvent::Sba results'
      # it_behaves_like 'it contains all TradeEvent::Exim results'
      it_behaves_like 'it contains all TradeEvent::Ustda results'
      it_behaves_like 'it contains all TradeEvent::Dl results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [TradeEvent::Ita, TradeEvent::Sba, TradeEvent::Exim,
           TradeEvent::Ustda, TradeEvent::Dl]
        end
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_events/v2/all_sources/aggregations.json' }
      end
    end

    context 'when q is specified' do
      context 'and is "2013"' do
        let(:params) { { q: '2013' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ita results that match "2013"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Ita] }
        end
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'trade_events/v2/all_sources/aggregations_with_query_2013.json' }
        end
      end
      context 'and is "Maximus"' do
        let(:params) { { q: 'Maximus' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Sba results that match "Maximus"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Sba] }
        end
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'trade_events/v2/all_sources/aggregations_with_query_maximus.json' }
        end
      end
      context 'and is "Baltimore"' do
        let(:params) { { q: 'Baltimore' } }
        it_behaves_like 'a successful search request'
        # it_behaves_like 'it contains all TradeEvent::Exim results that match "Baltimore"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Exim] }
        end
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'trade_events/v2/all_sources/aggregations_with_query_baltimore.json' }
        end
      end
      context 'and is "google"' do
        let(:params) { { q: 'google' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ustda results that match "google"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Ustda] }
        end
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'trade_events/v2/all_sources/aggregations_with_query_google.json' }
        end
      end
      context 'and is "international"' do
        let(:params) { { q: 'international', size: 100 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ita results that match "international"'
        it_behaves_like 'it contains all TradeEvent::Sba results that match "international"'
        # it_behaves_like 'it contains all TradeEvent::Exim results that match "international"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Ita, TradeEvent::Sba, TradeEvent::Exim, TradeEvent::Ustda] }
        end
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'trade_events/v2/all_sources/aggregations_with_query_international.json' }
        end
      end
      it_behaves_like "an empty result when a query doesn't match any documents"
    end

    context 'when countries is specified' do
      context 'and is "il"' do
        let(:params) { { countries: 'il' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ita results that match countries "il"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Ita] }
        end
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'trade_events/v2/all_sources/aggregations_with_countries_il.json' }
        end
      end
      context 'and is "fr,de"' do
        let(:params) { { countries: 'fr,de' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Sba results that match countries "fr,de"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Sba] }
        end
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'trade_events/v2/all_sources/aggregations_with_countries_fr_de.json' }
        end
      end
      context 'and is "US"' do
        let(:params) { { countries: 'US', size: 100 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ita results that match countries "US"'
        it_behaves_like 'it contains all TradeEvent::Sba results that match countries "US"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Ita, TradeEvent::Sba, TradeEvent::Ustda] }
        end
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'trade_events/v2/all_sources/aggregations_with_countries_us.json' }
        end
      end
      it_behaves_like "an empty result when a countries search doesn't match any documents"
    end

    context 'when industry is specified' do
      let(:params) { { industries: 'Dental Eq.,Renewable Energy' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results that match industry "DENTALS"'
      it_behaves_like 'it contains all TradeEvent::Ustda results that match industry "Renewable Energy"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeEvent::Ita, TradeEvent::Ustda] }
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_events/v2/all_sources/aggregations_with_industries.json' }
      end
      it_behaves_like "an empty result when an industries search doesn't match any documents"
    end

    context 'when sources is specified' do
      context 'and is set to "ITA"' do
        let(:params) { { sources: 'ITA' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ita results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Ita] }
        end
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'trade_events/v2/ita/aggregations.json' }
        end
      end
      context 'and is set to "SBA"' do
        let(:params) { { sources: 'SBA', size: 100 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Sba results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Sba] }
        end
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'trade_events/v2/sba/aggregations.json' }
        end
      end
      context 'and is set to "USTDA"' do
        let(:params) { { sources: 'USTDA', size: 100 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ustda results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Ustda] }
        end
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'trade_events/v2/ustda/aggregations.json' }
        end
      end
      context 'and is set to "DL"' do
        let(:params) { { sources: 'DL', size: 100 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Dl results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Dl] }
        end
        it_behaves_like 'it contains all expected aggregations' do
          let(:expected_json) { 'trade_events/v2/dl/aggregations.json' }
        end
      end
    end

    context 'when searching for field with non ascii characters using ascii characters' do
      let(:params) { { q: 'Sao' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results that match "Sao"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeEvent::Ita] }
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_events/v2/all_sources/aggregations_with_query_sao.json' }
      end
    end

    context 'when start_date is specified' do
      let(:params) { { sources: 'ITA', start_date: '2020-10-10 TO 2020-12-31' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results that match start_date [2020-10-10 TO 2020-12-31]'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeEvent::Ita] }
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_events/v2/ita/aggregations_with_start_date.json' }
      end
    end

    context 'when end_date is specified' do
      let(:params) { { sources: 'SBA', end_date: '2014-01-08 TO 2014-01-08' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Sba results that match end_date [2014-01-08 TO 2014-01-08]'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeEvent::Sba] }
      end
      it_behaves_like 'it contains all expected aggregations' do
        let(:expected_json) { 'trade_events/v2/sba/aggregations_with_end_date.json' }
      end
    end

    context 'when trade_regions is specified' do
      let(:params) { { sources: 'ITA', trade_regions: 'Southern Common Market, Asia Pacific Economic Cooperation' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results that match trade_regions "Southern Common Market" and "Asia Pacific Economic Cooperation"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeEvent::Ita] }
      end
    end

    context 'when world_regions is specified' do
      let(:params) { { sources: 'ITA', world_regions: 'Levant, South America' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results that match world_regions "Levant" and "South America"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeEvent::Ita] }
      end
    end
  end

  describe 'GET /trade_events/:id' do
    it_behaves_like 'a get by id endpoint with successful response', source: TradeEvent::Dl
    it_behaves_like 'a get by id endpoint with successful response', source: TradeEvent::Ita
    it_behaves_like 'a get by id endpoint with successful response', source: TradeEvent::Sba
    it_behaves_like 'a get by id endpoint with successful response', source: TradeEvent::Ustda
    it_behaves_like 'a get by id endpoint with not found response', resource_name: 'trade_events'
  end
end
