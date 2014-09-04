require 'spec_helper'

describe StateTradeLeadData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/state_trade_leads" }
  let(:fixtures_file) { "#{fixtures_dir}/state_trade_leads.json" }
  let(:importer) { StateTradeLeadData.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads state trade leads from specified resource' do
      StateTradeLead.should_receive(:index) do |trade_leads|
        trade_leads.size.should == 4
        trade_leads[0].should == expected[0]
        trade_leads[1].should == expected[1]
        trade_leads[2].should == expected[2]
        trade_leads[3].should == expected[3]
      end
      importer.import
    end
  end
end
