require 'spec_helper'

describe FbopenParser do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_leads/fbopen" }
  let(:results_dir) { "#{File.dirname(__FILE__)}/fbopen" }
  let(:subject) { FbopenParser.new }

  describe '#convert' do
    let(:srcsgt)          { open("#{fixtures_dir}/srcsgt_source").read }
    let(:expected_srcsgt) { JSON.parse open("#{results_dir}/srcsgt_result").read }
    it 'handles SRCSGT records' do
      expect(subject.convert(srcsgt)).to eq(expected_srcsgt)
    end

    let(:presol)          { open("#{fixtures_dir}/presol_source").read }
    let(:expected_presol) { JSON.parse open("#{results_dir}/presol_result").read }
    it 'handles PRESOL records' do
      expect(Rails.logger).not_to receive(:warn)
      expect(subject.convert(presol)).to include *expected_presol
    end

    let(:duplicatekey) { open("#{fixtures_dir}/duplicatekey_source").read }
    it 'warns on duplicate keys' do
      expect(Rails.logger).to receive(:warn).with(/Duplicate key 'OFFICE' on record: {:ntype=>\"PRESOL\"/)
      subject.convert(duplicatekey)
    end

    let(:all_records) { open("#{fixtures_dir}/complete_source").read }
    let(:expected_output) { JSON.parse(open("#{results_dir}/complete_output.json").read) }
    it 'handles all sample formats' do
      expect(subject.convert(all_records)).to eq(expected_output)
    end

    it 'works when given a file handle' do
      fh = open("#{fixtures_dir}/complete_source")
      expect(subject.convert(fh)).to eq(expected_output)
    end

    it 'logs exceptions' do
      fh = open("#{fixtures_dir}/complete_source")
      expect(subject).to receive(:transform).at_least(:once).and_return(nil)
      expect(Rails.logger).to receive(:error).at_least(:once).with(kind_of(NoMethodError))
      subject.convert(fh)
    end
  end
end
