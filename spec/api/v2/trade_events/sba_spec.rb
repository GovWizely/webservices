require 'spec_helper'

describe 'SBA Trade Events API V2', type: :request do
  include_context 'V2 headers'
  include_context 'TradeEvent::Sba data v2'

  describe 'GET /trade_events/sba/search' do
    let(:params) { { size: 100 } }
    before { get '/trade_events/sba/search', params, @v2_headers }
    subject { response }

    context 'when search parameters are empty' do
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Sba results'
    end

    context 'when q is specified' do
      let(:params) { { q: 'Maximus' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Sba results that match "Maximus"'
    end

    context 'when countries is specified' do
      let(:params) { { countries: 'fr,de' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Sba results that match countries "fr,de"'
    end

    xcontext 'when industries is specified' do
      pending 'All fixtures have no industry :-('
      let(:params) { { industries: 'abc,def' } }
      it_behaves_like 'a successful search request'
      it_behaves_like 'it contains all TradeEvent::Sba results that match countries "fr,de"'
    end
  end
end
