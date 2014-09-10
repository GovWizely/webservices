shared_examples 'it contains all expected results of source' do
  let(:results) do
    JSON.parse(response.body)['results']
      .select { |r| r['source'] == source }
  end

  it 'contains them all' do
    expected.should match_array(results)
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
