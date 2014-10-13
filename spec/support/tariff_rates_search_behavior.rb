shared_context 'all Tariff Rates fixture data' do
  include_context 'TariffRate::Australia data'
  include_context 'TariffRate::Korea data'
end

shared_context 'TariffRate::Australia data' do
  before(:all) do
    TariffRate::Australia.recreate_index
    TariffRate::AustraliaData.new(
        "#{Rails.root}/spec/fixtures/tariff_rates/australia/australia.csv").import

  end

  let(:all_australia_results) do
    JSON.parse(open(
                   "#{Rails.root}/spec/fixtures/tariff_rates/australia/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Australia results' do
  let(:source) { 'AUSTRALIA' }
  let(:expected) { all_australia_results }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Australia results that match "horses"' do
  let(:source) { 'AUSTRALIA' }
  let(:expected) { [all_australia_results[0]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Australia results that match countries "au"' do
  let(:source) { 'AUSTRALIA' }
  let(:expected) { [all_australia_results[0]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::Korea data' do
  before(:all) do
    TariffRate::Korea.recreate_index
    TariffRate::KoreaData.new(
        "#{Rails.root}/spec/fixtures/tariff_rates/korea/korea.csv").import

  end

  let(:all_korea_results) do
    JSON.parse(open(
                   "#{Rails.root}/spec/fixtures/tariff_rates/korea/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Korea results' do
  let(:source) { 'KOREA' }
  let(:expected) { all_korea_results }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Korea results that match "horses"' do
  let(:source) { 'KOREA' }
  let(:expected) { [all_korea_results[0]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Korea results that match countries "au"' do
  let(:source) { 'KOREA' }
  let(:expected) { [all_korea_results[0]] }
  it_behaves_like 'it contains all expected results of source'
end

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