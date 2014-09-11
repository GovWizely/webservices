require 'spec_helper'

describe 'Consolidated Trade Events API V1' do
  include_context 'all Trade Events fixture data'
  let(:v1_headers) { { 'Accept' => 'application/vnd.tradegov.webservices.v1' } }

  describe 'GET /trade_events/search' do
    let(:params) { { size: 100 } }
    before { get '/trade_events/search', params, v1_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results'
      it_behaves_like 'it contains all TradeEvent::Sba results'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { %w(ITA SBA) }
      end
    end

    context 'when q is specified' do
      context 'and is "2013"' do
        let(:params) { { q: '2013' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ita results that match "2013"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(ITA) }
        end
      end
      context 'and is "Maximus"' do
        let(:params) { { q: 'Maximus' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Sba results that match "Maximus"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(SBA) }
        end
      end
      context 'and is "international"' do
        let(:params) { { q: 'international', size: 100 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ita results that match "international"'
        it_behaves_like 'it contains all TradeEvent::Sba results that match "international"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(ITA SBA) }
        end
      end
    end

    context 'when countries is specified' do
      context 'and is "il"' do
        let(:params) { { countries: 'il' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ita results that match countries "il"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(ITA) }
        end
      end
      context 'and is "fr,de"' do
        let(:params) { { countries: 'fr,de' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Sba results that match countries "fr,de"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(SBA) }
        end
      end
      context 'and is "US"' do
        let(:params) { { countries: 'US', size: 100 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ita results that match countries "US"'
        it_behaves_like 'it contains all TradeEvent::Sba results that match countries "US"'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(ITA SBA) }
        end
      end
    end

    context 'when industry is specified' do
      let(:params) { { industry: 'DENTALS' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results that match industry "DENTALS"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { %w(ITA) }
      end
    end

    context 'when sources is specified' do
      context 'and is set to "ITA"' do
        let(:params) { { sources: 'ITA' } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Ita results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(ITA) }
        end
      end
      context 'and is set to "SBA"' do
        let(:params) { { sources: 'SBA', size: 100 } }
        it_behaves_like 'a successful search request'
        it_behaves_like 'it contains all TradeEvent::Sba results'
        it_behaves_like 'it contains only results with sources' do
          let(:sources) { %w(SBA) }
        end
      end
    end

    context 'when searching for field with non ascii characters using ascii characters' do
      let(:params) { { q: 'Sao' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Ita results that match "Sao"'
      it_behaves_like 'it contains only results with sources' do
        let(:sources) { %w(ITA) }
      end
    end
  end
end
