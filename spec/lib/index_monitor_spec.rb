require 'spec_helper'

describe IndexMonitor do
  before do
    class Mock
      include Indexable
      self.import_rate = 'Daily'
      self.mappings = {}
    end
    class Mock2
      include Indexable
      self.import_rate = 'Hourly'
      self.mappings = {}
    end
    Mock.recreate_index
    Mock2.recreate_index
  end

  describe '#check_indices' do
    let(:monitor) { IndexMonitor.new(%w(Mock Mock2)) }
    it 'runs without error when last_imported time is in the correct range' do
      Mock.touch_metadata
      Mock2.touch_metadata

      expect(monitor.check_indices).to be_truthy
    end

    it 'throws an error with the non-updated index when one index needs update' do
      Mock.touch_metadata(DateTime.now.utc - 25.hours)
      Mock2.touch_metadata
      expect { monitor.check_indices }.to raise_error('Indices need refresh:  ["test:webservices:mocks"]')
    end

    it 'throws an error with both non-updated indexes' do
      Mock.touch_metadata(DateTime.now.utc - 25.hours)
      Mock2.touch_metadata(DateTime.now.utc - 2.hours)
      expect { monitor.check_indices }.to raise_error('Indices need refresh:  ["test:webservices:mocks", "test:webservices:mock2s"]')
    end
  end

  describe '#compute_expected_last_imported' do
    let(:monitor) { IndexMonitor.new(['Mock']) }
    it 'computes the correct datetime when daily' do
      expect(monitor.compute_expected_last_imported('Daily').to_i).to eq((DateTime.now.utc - 25.hours).to_i)
    end

    it 'computes the correct datetime when hourly' do
      expect(monitor.compute_expected_last_imported('Hourly').to_i).to eq((DateTime.now.utc - 2.hours).to_i)
    end
  end

  describe '#get_metadata' do
    before do
      class Mock3
        include Indexable
        self.mappings = {}
      end
      Mock3.recreate_index
    end

    let(:monitor) { IndexMonitor.new(['Mock3']) }

    it 'raises an error when import_rate cannot be found' do
      index_name = Mock3.index_name
      expect { monitor.get_metadata(index_name) }.to raise_error("Index missing import rate:  #{index_name}")
    end

    it 'returns the correct metadata when import_rate is found' do
      index_name = Mock.index_name
      expect(monitor.get_metadata(index_name)).to eq(version: '', last_updated: '', last_imported: '', import_rate: 'Daily')
    end
  end
end
