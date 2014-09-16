require 'spec_helper'

describe FbopenParser do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/fbopen_leads" }
  let(:subject)      { FbopenParser.new }

  describe '#convert' do
    let(:srcsgt)          { open("#{fixtures_dir}/input_srcsgt").read }
    let(:expected_srcsgt) { JSON.parse open("#{fixtures_dir}/output_srcsgt").read }
    it 'handles SRCSGT records' do
      subject.convert(srcsgt).should == expected_srcsgt
    end

    let(:presol)          { open("#{fixtures_dir}/input_presol").read }
    let(:expected_presol) { JSON.parse open("#{fixtures_dir}/output_presol").read }
    it 'handles PRESOL records' do
      Rails.logger.should_not_receive(:warn)
      subject.convert(presol).should include *expected_presol
    end

    let(:duplicatekey)          { open("#{fixtures_dir}/input_duplicatekey").read }
    it 'warns on duplicate keys' do
      Rails.logger.should_receive(:warn).with(/Duplicate key 'OFFICE' on record: {:ntype=>\"PRESOL\"/)
      subject.convert(duplicatekey)
    end

    let(:all_records)           { open("#{fixtures_dir}/example_input").read }
    let(:expected_output) { JSON.parse(open("#{fixtures_dir}/example_output.json").read) }
    it 'handles all sample formats' do
      subject.convert(all_records).should == expected_output
    end

    it 'works when given a file handle' do
      fh = open("#{fixtures_dir}/example_input")
      subject.convert(fh).should == expected_output
    end

    it 'logs exceptions' do
      fh = open("#{fixtures_dir}/example_input")
      subject.should_receive(:transform).at_least(:once).and_return(nil)
      Rails.logger.should_receive(:error).at_least(:once).with(kind_of(NoMethodError))
      subject.convert(fh)
    end
  end
end
