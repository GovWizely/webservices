shared_context 'full results from response' do
  let(:full_results) do
    JSON.parse(response.body)['results']
      .select { |r| r['source'] == source_full_name(source) }
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

def source_full_name(code)
  full_names = {
    DPL: 'Denied Persons List (DPL) - Bureau of Industry and Security',
    EL:  'Entity List (EL) - Bureau of Industry and Security',
    FSE: 'Foreign Sanctions Evaders (FSE) - Treasury Department',
    DTC: 'ITAR Debarred (DTC) - State Department',
    ISN: 'Nonproliferation Sanctions (ISN) - State Department',
    PLC: 'Palestinian Legislative Council List (PLC) - Treasury Department',
    SSI: 'Sectoral Sanctions Identifications List (SSI) - Treasury Department',
    SDN: 'Specially Designated Nationals (SDN) - Treasury Department',
    UVL: 'Unverified List (UVL) - Bureau of Industry and Security',
  }
  full_names[code.to_sym] || code.to_s
end
