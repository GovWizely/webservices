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
      it_behaves_like 'it contains all TradeEvent::Exim results'
      it_behaves_like 'it contains all TradeEvent::Ustda results'
      it_behaves_like 'it contains all TradeEvent::Dl results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) do
          [TradeEvent::Ita, TradeEvent::Sba, TradeEvent::Exim,
           TradeEvent::Ustda, TradeEvent::Dl]
        end
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
      end
      context 'and is "Maximus"' do
        let(:params) { { q: 'Maximus' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Sba results that match "Maximus"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Sba] }
        end
      end
      context 'and is "Baltimore"' do
        let(:params) { { q: 'Baltimore' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Exim results that match "Baltimore"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Exim] }
        end
      end
      context 'and is "Wichita"' do
        let(:params) { { q: 'Wichita' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ustda results that match "Wichita"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Ustda] }
        end
      end
      context 'and is "aeronautical"' do
        let(:params) { { q: 'aeronautical' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ustda results that match "aeronautical"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Ustda] }
        end
      end
      context 'and is "international"' do
        let(:params) { { q: 'international', size: 100 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ita results that match "international"'
        it_behaves_like 'it contains all TradeEvent::Sba results that match "international"'
        it_behaves_like 'it contains all TradeEvent::Exim results that match "international"'
        it_behaves_like 'it contains all TradeEvent::Ustda results that match "international"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Ita, TradeEvent::Sba, TradeEvent::Exim, TradeEvent::Ustda] }
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
      end
      context 'and is "fr,de"' do
        let(:params) { { countries: 'fr,de' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Sba results that match countries "fr,de"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Sba] }
        end
      end
      context 'and is "US"' do
        let(:params) { { countries: 'US', size: 100 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ita results that match countries "US"'
        it_behaves_like 'it contains all TradeEvent::Sba results that match countries "US"'
        it_behaves_like 'it contains all TradeEvent::Ustda results that match countries "US"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Ita, TradeEvent::Sba, TradeEvent::Ustda] }
        end
      end
      it_behaves_like "an empty result when a countries search doesn't match any documents"
    end

    context 'when industry is specified' do
      let(:params) { { industries: "Dental Eq.,Energy \u0026 Mining" } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results that match industry "DENTALS"'
      it_behaves_like 'it contains all TradeEvent::Ustda results that match industry "mining"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeEvent::Ita, TradeEvent::Ustda] }
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
      end
      context 'and is set to "SBA"' do
        let(:params) { { sources: 'SBA', size: 100 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Sba results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Sba] }
        end
      end
      context 'and is set to "EXIM"' do
        let(:params) { { sources: 'EXIM', size: 100 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Exim results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Exim] }
        end
      end
      context 'and is set to "USTDA"' do
        let(:params) { { sources: 'USTDA', size: 100 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ustda results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Ustda] }
        end
      end
      context 'and is set to "DL"' do
        let(:params) { { sources: 'DL', size: 100 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Dl results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { [TradeEvent::Dl] }
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
    end

    context 'when start_date is specified' do
      let(:params) { { sources: 'ITA', start_date: '2020-10-10 TO 2020-12-31' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results that match start_date [2020-10-10 TO 2020-12-31]'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeEvent::Ita] }
      end
    end

    context 'when end_date is specified' do
      let(:params) { { sources: 'SBA', end_date: '2014-01-08 TO 2014-01-08' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Sba results that match end_date [2014-01-08 TO 2014-01-08]'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { [TradeEvent::Sba] }
      end
    end
  end
end
