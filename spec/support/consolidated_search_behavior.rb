shared_context 'full results from response' do
  let(:full_results) do
    JSON.parse(response.body)['results']
    .select { |r| r['source'].to_sym == source }
  end
  let(:got) do
    full_results.map { |f| @all_possible_full_results[source].index(f) }
  end
end

shared_examples 'it contains all expected results of source' do
  include_context 'full results from response'
  it 'contains them all' do
    expect(got).to match_array(expected)
  end
end

shared_examples 'it contains only results with sources' do
  let(:results) { JSON.parse(response.body)['results'] }
  let(:results_with_source_other_than_expected) do
    results.select { |r| !sources.include?(r['source']) }
  end
  it 'contains only results with sources' do
    expect(results_with_source_other_than_expected.length).to eq 0
  end
end