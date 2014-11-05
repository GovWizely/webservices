shared_context 'all Tariff Rates fixture data' do
  include_context 'TariffRate::Australia data'
  include_context 'TariffRate::CostaRica data'
  include_context 'TariffRate::ElSalvador data'
  include_context 'TariffRate::Guatemala data'
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
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TariffRate::Australia results that match "horses"' do
  let(:source) { 'AUSTRALIA' }
  let(:expected) { [all_australia_results[0], all_australia_results[2]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TariffRate::Australia results that match countries "us,au"' do
  let(:source) { 'AUSTRALIA' }
  let(:expected) { all_australia_results }
  it_behaves_like 'it contains all the expected results of source'
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
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TariffRate::Korea results that match "horses"' do
  let(:source) { 'KOREA' }
  let(:expected) { [all_korea_results[0]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TariffRate::Korea results that match countries "kp"' do
  let(:source) { 'KOREA' }
  let(:expected) { [all_korea_results[0]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_context 'TariffRate::CostaRica data' do
  before(:all) do
    TariffRate::CostaRica.recreate_index
    TariffRate::CostaRicaData.new(
        "#{Rails.root}/spec/fixtures/tariff_rates/costa_rica/costa_rica.csv").import
  end

  let(:all_costa_rica_results) do
    JSON.parse(open(
                   "#{Rails.root}/spec/fixtures/tariff_rates/costa_rica/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::CostaRica results' do
  let(:source) { 'COSTA_RICA' }
  let(:expected) { all_costa_rica_results }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TariffRate::CostaRica results that match "horses"' do
  let(:source) { 'COSTA_RICA' }
  let(:expected) { [all_costa_rica_results[0]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TariffRate::CostaRica results that match countries "cr"' do
  let(:source) { 'COSTA_RICA' }
  let(:expected) { [all_costa_rica_results[0]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_context 'TariffRate::ElSalvador data' do
  before(:all) do
    TariffRate::ElSalvador.recreate_index
    TariffRate::ElSalvadorData.new(
        "#{Rails.root}/spec/fixtures/tariff_rates/el_salvador/el_salvador.csv").import
  end

  let(:all_el_salvador_results) do
    JSON.parse(open(
                   "#{Rails.root}/spec/fixtures/tariff_rates/el_salvador/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::ElSalvador results' do
  let(:source) { 'EL_SALVADOR' }
  let(:expected) { all_el_salvador_results }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TariffRate::ElSalvador results that match "horses"' do
  let(:source) { 'EL_SALVADOR' }
  let(:expected) { [all_el_salvador_results[0]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TariffRate::ElSalvador results that match countries "cr"' do
  let(:source) { 'EL_SALVADOR' }
  let(:expected) { [all_el_salvador_results[0]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_context 'TariffRate::Guatemala data' do
  before(:all) do
    TariffRate::Guatemala.recreate_index
    TariffRate::GuatemalaData.new(
        "#{Rails.root}/spec/fixtures/tariff_rates/guatemala/guatemala.csv").import

  end

  let(:all_guatemala_results) do
    JSON.parse(open(
                   "#{Rails.root}/spec/fixtures/tariff_rates/guatemala/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Guatemala results' do
  let(:source) { 'GUATEMALA' }
  let(:expected) { all_guatemala_results }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TariffRate::Guatemala results that match "horses"' do
  let(:source) { 'GUATEMALA' }
  let(:expected) { [all_guatemala_results[0]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all TariffRate::Guatemala results that match countries "kp"' do
  let(:source) { 'GUATEMALA' }
  let(:expected) { [all_guatemala_results[0]] }
  it_behaves_like 'it contains all the expected results of source'
end

shared_examples 'it contains all the expected results of source' do
  let(:results) do
    JSON.parse(response.body)['results']
    .select { |r| r['source'] == source }
  end

  it 'contains them all' do
    expect(expected).to match_array(results)
  end
end

shared_examples 'it contains only the results with sources' do
  let(:results) { JSON.parse(response.body)['results'] }
  let(:results_with_source_other_than_expected) do
    results.select { |r| !sources.include?(r['source']) }
  end
  it 'contains only results with sources' do
    expect(results_with_source_other_than_expected.length).to eq 0
  end
end
