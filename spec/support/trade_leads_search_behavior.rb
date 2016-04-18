# -*- coding: utf-8 -*-
shared_context 'all Trade Leads fixture data' do
  include_context 'TradeLead::Australia data'
  include_context 'TradeLead::Fbopen data'
  include_context 'TradeLead::Canada data'
  include_context 'TradeLead::State data'
  include_context 'TradeLead::Uk data'
  include_context 'TradeLead::Mca data'
  include_context 'TradeLead::Ustda data'
end

shared_context 'TradeLead::Australia data' do
  before(:all) do
    TradeLead::Australia.recreate_index

    RSpec::Mocks.with_temporary_scope do
      allow(Date).to receive(:current).and_return(Date.parse('2013-01-28'))
      VCR.use_cassette('importers/trade_leads/australia.yml', record: :once) do
        TradeLead::AustraliaData.new(
          "#{Rails.root}/spec/fixtures/trade_leads/australia/trade_leads.csv",).import
      end
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[TradeLead::Australia] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/trade_leads/australia/results.json",).read,)
  end
end

shared_examples 'it contains all TradeLead::Australia results' do
  let(:source) { TradeLead::Australia }
  let(:expected) { [0, 1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::Australia results that match "equipment"' do
  let(:source) { TradeLead::Australia }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::Australia results that match industries "Health Care Medical"' do
  let(:source) { TradeLead::Australia }
  let(:expected) { [] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::Australia results where publish_date_amended is 2013-01-04' do
  let(:source) { TradeLead::Australia }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TradeLead::Canada data' do
  before(:all) do
    TradeLead::Canada.recreate_index
    VCR.use_cassette('importers/trade_leads/canada.yml', record: :once) do
      TradeLead::CanadaData.new(
        "#{Rails.root}/spec/fixtures/trade_leads/canada/canada_leads.csv",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[TradeLead::Canada] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/trade_leads/canada/results.json",).read,)
  end
end

shared_examples 'it contains all TradeLead::Canada results' do
  let(:source) { TradeLead::Canada }
  let(:expected) { [0, 1, 2, 3, 4] }
  it_behaves_like 'it contains all expected results of source with auto generated id'
end

shared_examples 'it contains all TradeLead::Canada aggregations' do
  let(:expected) do
    JSON.parse(open(
      "#{File.dirname(__FILE__)}/trade_leads/canada/aggregations.json",).read,)
  end
  it_behaves_like 'it contains all expected aggregations'
end

shared_examples 'it contains all TradeLead::Canada results that match "equipment"' do
  let(:source) { TradeLead::Canada }
  let(:expected) { [4] }
  it_behaves_like 'it contains all expected results of source with auto generated id'
end

shared_examples 'it contains all TradeLead::Canada results that match "Montée"' do
  let(:source) { TradeLead::Canada }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source with auto generated id'
end

shared_examples 'it contains all TradeLead::Canada results that match countries "kp"' do
  let(:source) { TradeLead::Canada }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::Canada results that match industries "Health Care Medical"' do
  let(:source) { TradeLead::Canada }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source with auto generated id'
end

shared_examples 'it contains all TradeLead::Canada results where publish_date is 2014-03-20' do
  let(:source) { TradeLead::Canada }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source with auto generated id'
end

shared_context 'TradeLead::Fbopen data' do
  before(:all) do
    TradeLead::Fbopen.recreate_index
    VCR.use_cassette('importers/trade_leads/fbopen/patch_source_short_input.yml', record: :once) do
      TradeLead::FbopenImporter::PatchData.new(
        "#{Rails.root}/spec/fixtures/trade_leads/fbopen/patch_source_short_input",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[TradeLead::Fbopen] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/trade_leads/fbopen/results.json",).read,)
  end
end

shared_examples 'it contains all TradeLead::Fbopen results' do
  let(:source) { TradeLead::Fbopen }
  let(:expected) { [0, 1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::Fbopen results that match "equipment"' do
  let(:source) { TradeLead::Fbopen }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::Fbopen results that match countries "cr"' do
  let(:source) { TradeLead::Fbopen }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::Fbopen results that match industries "Health Care Medical"' do
  let(:source) { TradeLead::Fbopen }
  let(:expected) { [] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TradeLead::State data' do
  before(:all) do
    TradeLead::State.recreate_index

    RSpec::Mocks.with_temporary_scope do
      allow(Date).to receive(:current).and_return(Date.parse('2013-06-11'))
      VCR.use_cassette('importers/trade_leads/state.yml', record: :once) do
        TradeLead::StateData.new(
          "#{Rails.root}/spec/fixtures/trade_leads/state/state_trade_leads.json",).import
      end
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[TradeLead::State] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/trade_leads/state/results.json",).read,)
  end
end

shared_examples 'it contains all TradeLead::State results' do
  let(:source) { TradeLead::State }
  let(:expected) { [0, 1, 2, 3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::State results that match "equipment"' do
  let(:source) { TradeLead::State }
  let(:expected) { [] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it search among tags of TradeLead::State that match "sanitation"' do
  let(:source) { TradeLead::State }
  let(:expected) { [3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::State results that match countries "cr"' do
  let(:source) { TradeLead::State }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::State results that match industries "Health Care Medical"' do
  let(:source) { TradeLead::State }
  let(:expected) { [0, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::State results that match country "QA"' do
  let(:source) { TradeLead::State }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::State results where end_date is 2014-03-06' do
  let(:source) { TradeLead::State }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::State results that match world_regions "Africa"' do
  let(:source) { TradeLead::State }
  let(:expected) { [3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TradeLead::Uk data' do
  before(:all) do
    TradeLead::Uk.recreate_index
    VCR.use_cassette('importers/trade_leads/uk.yml', record: :once) do
      TradeLead::UkData.new(
        "#{Rails.root}/spec/fixtures/trade_leads/uk/Notices.xml",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[TradeLead::Uk] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/trade_leads/uk/results.json",).read,)
  end
end

shared_examples 'it contains all TradeLead::Uk results' do
  let(:source) { TradeLead::Uk }
  let(:expected) { [0, 1, 2, 3, 4, 5, 6, 7, 8] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::Uk results that match "equipment"' do
  let(:source) { TradeLead::Uk }
  let(:expected) { [0, 6, 7] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TradeLead::Mca data' do
  before(:all) do
    TradeLead::Mca.recreate_index
    VCR.use_cassette('importers/trade_leads/mca.yml', record: :once) do
      TradeLead::McaData.new(
        "#{Rails.root}/spec/fixtures/trade_leads/mca/mca_leads.xml",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[TradeLead::Mca] = JSON.parse(open("#{Rails.root}/spec/support/trade_leads/mca/results.json").read)
  end
end

shared_examples 'it contains all TradeLead::Mca results' do
  let(:source) { TradeLead::Mca }
  let(:expected) { [0, 1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::Mca results that match trade_regions "West African Economic and Monetary Union"' do
  let(:source) { TradeLead::Mca }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::Mca results that match world_regions "Africa"' do
  let(:source) { TradeLead::Mca }
  let(:expected) { [0, 1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TradeLead::Ustda data' do
  before(:all) do
    TradeLead::Ustda.recreate_index

    RSpec::Mocks.with_temporary_scope do
      allow(Date).to receive(:current).and_return(Date.parse('2015-12-18'))
      VCR.use_cassette('importers/trade_leads/ustda.yml', record: :once) do
        TradeLead::UstdaData.new(
          "#{Rails.root}/spec/fixtures/trade_leads/ustda/leads.xml",
          "#{Rails.root}/spec/fixtures/trade_leads/ustda/rss.xml",).import
      end
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[TradeLead::Ustda] = JSON.parse(open("#{File.dirname(__FILE__)}/trade_leads/ustda/results.json").read)
  end
end

shared_examples 'it contains all TradeLead::Ustda results' do
  let(:source) { TradeLead::Ustda }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::Ustda results that match "equipment"' do
  let(:source) { TradeLead::Ustda }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::Ustda results with trade_regions' do
  let(:source) { TradeLead::Ustda }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TradeLead::Ustda results that match world_regions "Africa"' do
  let(:source) { TradeLead::Ustda }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end
