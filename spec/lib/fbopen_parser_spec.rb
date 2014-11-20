require 'spec_helper'

describe FbopenParser do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_leads/fbopen" }
  let(:subject)      { FbopenParser.new }

  describe '#convert' do
    let(:srcsgt)          { open("#{fixtures_dir}/input_srcsgt").read }
    let(:expected_srcsgt) { JSON.parse open("#{fixtures_dir}/output_srcsgt").read }
    it 'handles SRCSGT records' do
      expect(subject.convert(srcsgt)).to eq(expected_srcsgt)
    end

    let(:presol)          { open("#{fixtures_dir}/input_presol").read }
    let(:expected_presol) { JSON.parse open("#{fixtures_dir}/output_presol").read }
    it 'handles PRESOL records' do
      expect(Rails.logger).not_to receive(:warn)
      expect(subject.convert(presol)).to include *expected_presol
    end

    let(:duplicatekey)          { open("#{fixtures_dir}/input_duplicatekey").read }
    it 'warns on duplicate keys' do
      expect(Rails.logger).to receive(:warn).with(/Duplicate key 'OFFICE' on record: {:ntype=>\"PRESOL\"/)
      subject.convert(duplicatekey)
    end

    let(:all_records)           { open("#{fixtures_dir}/example_input").read }
    let(:expected_output) { JSON.parse(open("#{fixtures_dir}/example_output.json").read) }
    it 'handles all sample formats' do
      expect(subject.convert(all_records)).to eq(expected_output)
    end

    it 'works when given a file handle' do
      fh = open("#{fixtures_dir}/example_input")
      expect(subject.convert(fh)).to eq(expected_output)
    end

    it 'logs exceptions' do
      fh = open("#{fixtures_dir}/example_input")
      expect(subject).to receive(:transform).at_least(:once).and_return(nil)
      expect(Rails.logger).to receive(:error).at_least(:once).with(kind_of(NoMethodError))
      subject.convert(fh)
    end
  end
end
