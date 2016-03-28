require 'spec_helper'
require 'csv'

describe CanEnsureCsvHeaders do
  before do
    class MockData
      include ::CanEnsureCsvHeaders
      def import
        csv_path = "#{Rails.root}/spec/fixtures/can_ensure_csv_headers.csv"
        rows = CSV.parse(open(csv_path).read, headers: true, header_converters: :symbol)
        ensure_expected_headers(rows.first)
      end
    end
  end

  after { Object.send(:remove_const, :MockData) }

  describe '#ensure_expected_headers' do
    context 'when expected headers match CSV fixture file' do
      before { MockData.expected_csv_headers = %i(foo bar_baz) }
      it 'does not raise an error' do
        expect { MockData.new.import }.not_to raise_error
      end
    end

    context 'when expected headers do not match CSV fixture file' do
      before { MockData.expected_csv_headers = %i(foobius bar_baz) }
      it 'raises an error' do
        expect { MockData.new.import }.to raise_error(
          'CSV key names in source for MockData are not as ' \
          'expected. Missing keys: foobius. Unrecognized keys: foo.',)
      end
    end
  end
end
