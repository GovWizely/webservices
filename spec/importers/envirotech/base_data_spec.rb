require 'spec_helper'

describe Envirotech::BaseData do
  let(:fixtures_file) do
    "#{Rails.root}/spec/fixtures/envirotech/base.json"
  end

  subject { described_class.new fixtures_file }

  describe '#fetch_data' do
    it 'is as expected' do
      expect(subject.send(:fetch_data)).to eq(JSON.parse(File.open(fixtures_file).read))
    end
  end
end
