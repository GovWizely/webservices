require 'spec_helper'

describe SemanticQueryService do
  let(:sqs) { SemanticQueryService.new(url: 'https://gahaag0204.execute-api.us-east-1.amazonaws.com/prod/semantic_query_service?q=ORIGINAL_VALUE') }

  subject do
    VCR.use_cassette('importers/data_sources/semantic_query_service/request.yml') do
      sqs.parse('scuba in cuba and asia')
    end
  end

  it 'contains the correct filters and modified query' do
    expect(subject.query).to eq('scuba in and')
    expect(subject.filters.country_name).to eq(%w(Cuba))
    expect(subject.filters.world_region).to eq(%w(Asia))
  end
end
