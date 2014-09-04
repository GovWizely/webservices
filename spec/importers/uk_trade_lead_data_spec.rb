require 'spec_helper'

describe UkTradeLeadData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/uk_trade_leads" }
  let(:fixtures_file) { "#{fixtures_dir}/uk_trade_leads.csv" }
  let(:importer) { UkTradeLeadData.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{fixtures_dir}/results.yaml") }

  describe '#import' do
    it 'loads UK trade leads from specified resource' do
      UkTradeLead.should_receive(:index) do |trade_leads|
        trade_leads.size.should == 3
        trade_leads[0].should == expected[0]
        trade_leads[1].should == expected[1]
        trade_leads[2].should == expected[2]
      end
      importer.import
    end
  end
end
