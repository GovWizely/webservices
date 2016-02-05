shared_context 'full results from response' do
  let(:full_results) do
    JSON.parse(response.body)['results'].select do |r|
      r['source'] == source_full_name(source)
    end.map do |r|
      r.delete('score')
      r
    end
  end
  let(:got) do
    full_results.map do |f|
      @all_possible_full_results[source].index(f)
    end
  end
end

shared_context 'non id results from response' do
  let(:full_results) do
    JSON.parse(response.body)['results'].map do |r|
      r.except('id', 'score') if r['source'] == source_full_name(source)
    end.compact
  end
  let(:got) do
    full_results.map do |f|
      @all_possible_full_results[source].index(f)
    end
  end
end

shared_context 'result ids from response' do
  let(:ids) do
    JSON.parse(response.body)['results'].map do |r|
      r['id'] if r['source'] == source_full_name(source)
    end.compact
  end
end

shared_context 'full results from response without source' do
  let(:full_results) do
    JSON.parse(response.body)['results'].map do |r|
      r.delete('score')
      r
    end
  end
  let(:got) do
    full_results.map do |f|
      @all_possible_full_results[source].index(f)
    end
  end
end

shared_examples 'it contains all expected results of source' do
  include_context 'full results from response'
  it 'contains them all' do
    expect(got).to match_array(expected)
  end
end

shared_examples 'it contains all expected results of source with auto generated id' do
  include_context 'non id results from response'
  include_context 'result ids from response'
  it 'contains them all' do
    expect(got).to match_array(expected)
  end

  it 'contains ids' do
    expect(ids).to be_present
    ids.each do |id|
      expect(id).to be_present
    end
  end
end

shared_examples 'it contains all expected results without source' do
  include_context 'full results from response without source'
  it 'contains them all' do
    expect(got).to match_array(expected)
  end
end

shared_examples 'it contains only results with sources' do
  let(:results) { JSON.parse(response.body)['results'] }
  let(:source_full_names) { sources.map { |s| source_full_name(s) } }
  let(:results_with_source_other_than_expected) do
    results.select { |r| !source_full_names.include?(r['source']) }
  end

  it 'contains only results with sources' do
    expect(results_with_source_other_than_expected.length).to eq 0
  end
end

def source_full_name(source)
  (source.source.is_a?(Hash) && source.source[:full_name]) || source.source[:code]
end

shared_examples 'it contains all expected results' do
  let(:got) do
    JSON.parse(response.body, symbolize_names: true)[:results].map do |r|
      @all_possible_full_results.index(r)
    end
  end
  it 'contains them all' do
    expect(got).to match_array(expected)
  end
end

shared_examples 'it contains all expected aggregations' do
  let(:got) { JSON.parse(response.body)['aggregations'] }
  let(:expected) { JSON.parse(open("#{File.dirname(__FILE__)}/#{expected_json}").read) }
  it { expect(got).to eql(expected) }
end
