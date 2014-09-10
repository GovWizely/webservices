shared_context 'all Trade Events fixture data' do
  include_context 'SBA data'
end

shared_context 'SBA data' do
  before(:all) do
    TradeEvent::Sba.recreate_index
    TradeEvent::SbaData.new(
        "#{Rails.root}/spec/fixtures/trade_events/sba/new_events_listing.xml?offset=0",
        reject_if_ends_before: Date.parse('2013-01-11'),
      ).import
  end

  before do
    Date.stub(:current).and_return(Date.parse('2013-01-11'))
  end

  let(:all_sba_results) do
    JSON.parse(open(
      "#{Rails.root}/spec/fixtures/trade_events/sba/expected_results.json").read)
  end
end

shared_examples 'it contains all TradeEvent::Sba results' do
  let(:source) { 'SBA' }
  let(:expected) { all_sba_results }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Sba results that match "Maximus"' do
  let(:source) { 'SBA' }
  let(:expected) { all_sba_results[0..3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Sba results that match countries "fr,de"' do
  let(:source) { 'SBA' }
  let(:expected) { [all_sba_results[9], all_sba_results[13]] }
  it_behaves_like 'it contains all expected results of source'
end
