shared_context 'all Trade Events fixture data' do
  include_context 'TradeEvent::Sba data'
  include_context 'TradeEvent::Ita data'
  include_context 'TradeEvent::Exim data'
  include_context 'TradeEvent::Ustda data'
  include_context 'TradeEvent::Dl data'
end

shared_context 'all Trade Events v2 fixture data' do
  include_context 'TradeEvent::Sba data v2'
  include_context 'TradeEvent::Ita data v2'
  include_context 'TradeEvent::Exim data v2'
  include_context 'TradeEvent::Ustda data v2'
  include_context 'TradeEvent::Dl data v2'
end

shared_context 'TradeEvent::Ita data' do
  before(:all) do
    TradeEvent::Ita.recreate_index
    
    VCR.use_cassette("TradeEvent_ItaData/_import/loads_ITA_trade_events_from_specified_resource", :record => :new_episodes) do
      TradeEvent::ItaData.new(
        "#{Rails.root}/spec/fixtures/trade_events/ita/trade_events.xml").import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[:ITA] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/trade_events/ita/results.json").read)
  end
end

shared_context 'TradeEvent::Ita data v2' do
  before(:all) do
    TradeEvent::Ita.recreate_index

    VCR.use_cassette("TradeEvent_ItaData/_import/loads_ITA_trade_events_from_specified_resource", :record => :new_episodes) do
      TradeEvent::ItaData.new(
        "#{Rails.root}/spec/fixtures/trade_events/ita/trade_events.xml").import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[:ITA] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/trade_events/ita/results_v2.json").read)
  end
end

shared_examples 'it contains all TradeEvent::Ita results' do
  let(:source) { :ITA }
  let(:expected) { [0, 1, 2, 3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Ita results that match "2013"' do
  let(:source) { :ITA }
  let(:expected) { [0, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Ita results that match "international"' do
  let(:source) { :ITA }
  let(:expected) { [1, 2, 3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Ita results that match countries "il"' do
  let(:source) { :ITA }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Ita results that match countries "US"' do
  let(:source) { :ITA }
  let(:expected) { [1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Ita results that match industry "Materials"' do
  let(:source) { :ITA }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Ita results that match "Sao"' do
  let(:source) { :ITA }
  let(:expected) { [3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TradeEvent::Sba data' do
  before(:all) do
    TradeEvent::Sba.recreate_index
    TradeEvent::SbaData.new(
      "#{Rails.root}/spec/fixtures/trade_events/sba/new_events_listing.xml?offset=0",
      reject_if_ends_before: Date.parse('2013-01-11'),
    ).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:SBA] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/trade_events/sba/results.json").read)
  end

  before do
    allow(Date).to receive(:current).and_return(Date.parse('2013-01-11'))
  end
end

shared_context 'TradeEvent::Sba data v2' do
  before(:all) do
    TradeEvent::Sba.recreate_index
    TradeEvent::SbaData.new(
      "#{Rails.root}/spec/fixtures/trade_events/sba/new_events_listing.xml?offset=0",
      reject_if_ends_before: Date.parse('2013-01-11'),
    ).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:SBA] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/trade_events/sba/results_v2.json").read)
  end

  before do
    allow(Date).to receive(:current).and_return(Date.parse('2013-01-11'))
  end
end

shared_examples 'it contains all TradeEvent::Sba results' do
  let(:source) { :SBA }
  let(:expected) { (0..16).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Sba results that match "Maximus"' do
  let(:source) { :SBA }
  let(:expected) { [0, 1, 3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Sba results that match "international"' do
  let(:source) { :SBA }
  let(:expected) { [11, 12, 16] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Sba results that match countries "fr,de"' do
  let(:source) { :SBA }
  let(:expected) { [9, 13] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Sba results that match countries "US"' do
  let(:source) { :SBA }
  let(:expected) { [0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12, 14, 15, 16] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TradeEvent::Exim data' do
  before(:all) do
    TradeEvent::Exim.recreate_index
    TradeEvent::EximData.new(
      "#{Rails.root}/spec/fixtures/trade_events/exim/trade_events.xml",
      reject_if_ends_before: Date.parse('2013-01-11'),
    ).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:EXIM] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/trade_events/exim/results.json").read)
  end

  before do
    allow(Date).to receive(:current).and_return(Date.parse('2013-01-11'))
  end
end

shared_context 'TradeEvent::Exim data v2' do
  before(:all) do
    TradeEvent::Exim.recreate_index
    TradeEvent::EximData.new(
      "#{Rails.root}/spec/fixtures/trade_events/exim/trade_events.xml",
      reject_if_ends_before: Date.parse('2013-01-11'),
    ).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:EXIM] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/trade_events/exim/results_v2.json").read)
  end

  before do
    allow(Date).to receive(:current).and_return(Date.parse('2013-01-11'))
  end
end

shared_examples 'it contains all TradeEvent::Exim results' do
  let(:source) { :EXIM }
  let(:expected) { (0..14).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Exim results that match "international"' do
  let(:source) { :EXIM }
  let(:expected) { [0, 2, 9, 11] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Exim results that match "Baltimore"' do
  let(:source) { :EXIM }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TradeEvent::Ustda data' do
  before(:all) do
    TradeEvent::Ustda.recreate_index

    VCR.use_cassette("TradeEvent_UstdaData/_import/loads_events_from_specified_resource", :record => :new_episodes) do
      TradeEvent::UstdaData.new("#{Rails.root}/spec/fixtures/trade_events/ustda/events.csv").import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[:USTDA] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/trade_events/ustda/results.json").read)
  end

  before do
    allow(Date).to receive(:current).and_return(Date.parse('2013-01-11'))
  end
end

shared_context 'TradeEvent::Ustda data v2' do
  before(:all) do
    TradeEvent::Ustda.recreate_index
    VCR.use_cassette("TradeEvent_UstdaData/_import/loads_events_from_specified_resource", :record => :new_episodes) do
      TradeEvent::UstdaData.new("#{Rails.root}/spec/fixtures/trade_events/ustda/events.csv").import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[:USTDA] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/trade_events/ustda/results_v2.json").read)
  end

  before do
    allow(Date).to receive(:current).and_return(Date.parse('2013-01-11'))
  end
end

shared_examples 'it contains all TradeEvent::Ustda results' do
  let(:source) { :USTDA }
  let(:expected) { (0..4).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Ustda results that match "international"' do
  let(:source) { :USTDA }
  let(:expected) { [4] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Ustda results that match "Wichita"' do
  let(:source) { :USTDA }
  let(:expected) { [4] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Ustda results that match "aeronautical"' do
  let(:source) { :USTDA }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Ustda results that match countries "US"' do
  let(:source) { :USTDA }
  let(:expected) { (0..4).to_a }
  it_behaves_like 'it contains all expected results of source'
end
shared_examples 'it contains all TradeEvent::Ustda results that match industry "mining"' do
  let(:source) { :USTDA }
  let(:expected) { [0, 3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TradeEvent::Dl data' do
  before(:all) do
    TradeEvent::Dl.recreate_index
    TradeEvent::DlData.new(
      "#{Rails.root}/spec/fixtures/trade_events/dl/trade_events.xml",
    ).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:DL] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/trade_events/dl/results.json").read)
  end

  before do
    allow(Date).to receive(:current).and_return(Date.parse('2013-01-11'))
  end
end

shared_context 'TradeEvent::Dl data v2' do
  before(:all) do
    TradeEvent::Dl.recreate_index
    TradeEvent::DlData.new(
      "#{Rails.root}/spec/fixtures/trade_events/dl/trade_events.xml",
    ).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:DL] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/trade_events/dl/results_v2.json").read)
  end

  before do
    allow(Date).to receive(:current).and_return(Date.parse('2013-01-11'))
  end
end

shared_examples 'it contains all TradeEvent::Dl results' do
  let(:source) { :DL }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeEvent::Dl results that match "Bangladesh"' do
  let(:source) { :DL }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end
