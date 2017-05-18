require 'spec_helper'

describe IndexMonitor do
  before do
    class Mock
      include Indexable
      analyze_by :snowball_asciifolding_nostop
      self.import_rate = 'Daily'
      self.mappings = {}
    end
    class Mock2
      include Indexable
      analyze_by :snowball_asciifolding_nostop
      self.import_rate = 'Hourly'
      self.mappings = {}
    end
    class Mock3
      include Indexable
      analyze_by :snowball_asciifolding_nostop
      self.import_rate = 'Weekly'
      self.mappings = {}
    end
    Mock.recreate_index
    Mock2.recreate_index
    Mock3.recreate_index
  end

  describe '#check_indices' do
    let(:monitor) { IndexMonitor.new(%w(Mock Mock2 Mock3)) }
    it 'runs without error when last_imported time is in the correct range' do
      Mock.touch_metadata
      Mock2.touch_metadata
      Mock3.touch_metadata

      expect(monitor.check_indices).to be_truthy
    end

    it 'throws an error with the non-updated index when one index needs update' do
      Mock.touch_metadata(DateTime.now.utc - 25.hours)
      Mock2.touch_metadata
      Mock3.touch_metadata
      expect { monitor.check_indices }.to raise_error('Indices need refresh: ["test:webservices:mocks"]. Indices may be empty: [].')
    end

    it 'throws an error with all non-updated indexes' do
      Mock.touch_metadata(DateTime.now.utc - 25.hours)
      Mock2.touch_metadata(DateTime.now.utc - 2.hours)
      Mock3.touch_metadata(DateTime.now.utc - 169.hours)
      expect { monitor.check_indices }.to raise_error('Indices need refresh: ["test:webservices:mocks", "test:webservices:mock2s", "test:webservices:mock3s"]. Indices may be empty: [].')
    end

    it 'throws an error when the last_imported time is blank' do
      Mock.touch_metadata('')
      Mock2.touch_metadata
      Mock3.touch_metadata
      expect { monitor.check_indices }.to raise_error('Indices need refresh: []. Indices may be empty: ["test:webservices:mocks"].')
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

    it 'computes the correct datetime when weekly' do
      expect(monitor.compute_expected_last_imported('Weekly').to_i).to eq((DateTime.now.utc - 169.hours).to_i)
    end
  end

  describe '#get_metadata' do
    before do
      class Mock4
        include Indexable
        analyze_by :snowball_asciifolding_nostop
        self.mappings = {}
      end
      Mock4.recreate_index
    end

    let(:monitor) { IndexMonitor.new(['Mock4']) }

    it 'raises an error when import_rate cannot be found' do
      index_name = Mock4.index_name
      expect { monitor.get_metadata(index_name) }.to raise_error("Index missing import rate:  #{index_name}")
    end

    it 'returns the correct metadata when import_rate is found' do
      index_name = Mock.index_name
      expect(monitor.get_metadata(index_name)).to eq(version: '', last_updated: '', last_imported: '', import_rate: 'Daily')
    end
  end
end
