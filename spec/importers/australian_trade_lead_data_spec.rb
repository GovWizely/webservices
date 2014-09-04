require 'spec_helper'

describe AustralianTradeLeadData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/australian_trade_leads" }
  let(:fixtures_file) { "#{fixtures_dir}/trade_leads.csv" }
  let(:importer) { AustralianTradeLeadData.new(fixtures_file) }
  let(:trade_leads_hash) { YAML.load_file("#{fixtures_dir}/trade_leads.yaml") }

  describe '#import' do
    it 'loads trade leads from specified resource' do
      AustralianTradeLead.should_receive(:index) do |trade_leads|
        trade_leads.size.should == 3
        trade_leads[0].should == trade_leads_hash[0]
        trade_leads[1].should == trade_leads_hash[1]
        trade_leads[2].should == trade_leads_hash[2]
      end
      importer.import
    end
  end
end
