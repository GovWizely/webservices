require 'spec_helper'

describe Indexable do
  class MockModel
    extend Indexable
  end

  describe '.prepare_record_for_indexing' do
    context 'given a record with ttl and _timestamp settings' do
      let(:now) { Time.now.to_i * 1000 }
      let(:record) do
        { ttl:        '1d',
          _timestamp: now,
          foo:        'bar',
          yin:        'yang',
          id:         1337 }
      end
      subject { MockModel.send(:prepare_record_for_indexing, record) }

      it do
        should eq(body:      { foo: 'bar', yin: 'yang' },
                  id:        1337,
                  index:     'test:webservices:mock_models',
                  timestamp: now,
                  ttl:       '1d',
                  type:      :mock_model)
      end
    end
  end
end
