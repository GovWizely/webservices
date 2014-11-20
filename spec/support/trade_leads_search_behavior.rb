shared_context 'all Trade Leads fixture data' do
  include_context 'TradeLead::Australia data'
  include_context 'TradeLead::Fbopen data'
  include_context 'TradeLead::Canada data'
  include_context 'TradeLead::State data'
  include_context 'TradeLead::Uk data'
end

shared_context 'TradeLead::Australia data' do
  before(:all) do
    TradeLead::Australia.recreate_index
    TradeLead::AustraliaData.new(
        "#{Rails.root}/spec/fixtures/trade_leads/australia/trade_leads.csv").import
  end

  let(:all_australia_results) do
    JSON.parse(open(
                   "#{Rails.root}/spec/fixtures/trade_leads/australia/results.json").read)
  end
end

shared_examples 'it contains all TradeLead::Australia results' do
  let(:source) { 'AUSTRALIA' }
  let(:expected) { all_australia_results }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::Australia results that match "equipment"' do
  let(:source) { 'AUSTRALIA' }
  let(:expected) { [all_australia_results[1], all_australia_results[2]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::Australia results that match industries "Health Care Medical"' do
  let(:source) { 'AUSTRALIA' }
  let(:expected) { [] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_context 'TradeLead::Canada data' do
  before(:all) do
    TradeLead::Canada.recreate_index
    TradeLead::CanadaData.new(
        "#{Rails.root}/spec/fixtures/trade_leads/canada/canada_leads.csv").import

  end

  let(:all_canada_results) do
    JSON.parse(open(
                   "#{Rails.root}/spec/fixtures/trade_leads/canada/results.json").read)
  end
end
shared_examples 'it contains all TradeLead::Canada results' do
  let(:source) { 'CANADA' }
  let(:expected) { all_canada_results }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::Canada results that match "equipment"' do
  let(:source) { 'CANADA' }
  let(:expected) { [all_canada_results[2]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::Canada results that match "Montée"' do
  let(:source) { 'CANADA' }
  let(:expected) { [all_canada_results[4]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::Canada results that match countries "kp"' do
  let(:source) { 'CANADA' }
  let(:expected) { [all_canada_results[0]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::Canada results that match industries "Health Care Medical"' do
  let(:source) { 'CANADA' }
  let(:expected) { [all_canada_results[1]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_context 'TradeLead::Fbopen data' do
  before(:all) do
    TradeLead::Fbopen.recreate_index
    TradeLead::FbopenData.new(
        "#{Rails.root}/spec/fixtures/trade_leads/fbopen/short_input").import
  end

  let(:all_fbopen_results) do
    JSON.parse(open(
                   "#{Rails.root}/spec/fixtures/trade_leads/fbopen/results.json").read)
  end
end

shared_examples 'it contains all TradeLead::Fbopen results' do
  let(:source) { 'FBO' }
  let(:expected) { all_fbopen_results }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::Fbopen results that match "equipment"' do
  let(:source) { 'FBO' }
  let(:expected) { [all_fbopen_results[4]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::Fbopen results that match countries "cr"' do
  let(:source) { 'FBO' }
  let(:expected) { [all_fbopen_results[0]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::Fbopen results that match industries "Health Care Medical"' do
  let(:source) { 'FBO' }
  let(:expected) { [] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_context 'TradeLead::State data' do
  before(:all) do
    TradeLead::State.recreate_index
    TradeLead::StateData.new(
        "#{Rails.root}/spec/fixtures/trade_leads/state/state_trade_leads.json").import
  end

  let(:all_state_results) do
    JSON.parse(open("#{Rails.root}/spec/fixtures/trade_leads/state/results.json").read)
  end
end

shared_examples 'it contains all TradeLead::State results' do
  let(:source) { 'STATE' }
  let(:expected) { all_state_results }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::State results that match "equipment"' do
  let(:source) { 'STATE' }
  let(:expected) { [] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it search among tags of TradeLead::State that match "sanitation"' do
  let(:source) { 'STATE' }
  let(:expected) { [all_state_results[3]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::State results that match countries "cr"' do
  let(:source) { 'STATE' }
  let(:expected) { [all_state_results[0]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::State results that match industries "Health Care Medical"' do
  let(:source) { 'STATE' }
  let(:expected) { [all_state_results[0], all_state_results[2]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::State results that match country "QA"' do
  let(:source) { 'STATE' }
  let(:expected) { [all_state_results[2]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_context 'TradeLead::Uk data' do
  before(:all) do
    TradeLead::Uk.recreate_index
    TradeLead::UkData.new(
        "#{Rails.root}/spec/fixtures/trade_leads/uk/uk_trade_leads.csv").import
  end

  let(:all_uk_results) do
    JSON.parse(open("#{Rails.root}/spec/fixtures/trade_leads/uk/results.json").read)
  end
end

shared_examples 'it contains all TradeLead::Uk results' do
  let(:source) { 'UK' }
  let(:expected) { all_uk_results }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::Uk results that match "equipment"' do
  let(:source) { 'UK' }
  let(:expected) { [] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::Uk results that match countries "kp"' do
  let(:source) { 'UK' }
  let(:expected) { [all_uk_results[0]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TradeLead::Uk results that match industries "Health Care Medical"' do
  let(:source) { 'UK' }
  let(:expected) { [] }
  it_behaves_like 'it contains all the expected results of source'
end
