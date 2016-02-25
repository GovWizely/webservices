require 'spec_helper'

describe SalesforceArticle::BaseData do
  let(:base) { described_class.new }

  it 'returns the correct error for query_string when there is no subclass' do
    expect { base.query_string }.to raise_error('Must be overridden by subclass')
  end
end
