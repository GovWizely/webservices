shared_context 'all Tariff Rates fixture data' do
  include_context 'TariffRate::Australia data'
  include_context 'TariffRate::CostaRica data'
  include_context 'TariffRate::ElSalvador data'
  include_context 'TariffRate::Guatemala data'
  include_context 'TariffRate::SouthKorea data'
end

shared_context 'TariffRate::Australia data' do
  before(:all) do
    TariffRate::Australia.recreate_index
    TariffRate::AustraliaData.new(
        "#{Rails.root}/spec/fixtures/tariff_rates/australia/australia.csv").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::Australia] = JSON.parse(open(
                   "#{Rails.root}/spec/fixtures/tariff_rates/australia/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Australia results' do
  let(:source) { TariffRate::Australia }
  let(:expected) { [0, 1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Australia results that match "horses"' do
  let(:source) { TariffRate::Australia }
  let(:expected) { [0, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Australia results that match countries "us,au"' do
  let(:source) { TariffRate::Australia }
  let(:expected) { [0, 1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::SouthKorea data' do
  before(:all) do
    TariffRate::SouthKorea.recreate_index
    TariffRate::SouthKoreaData.new(
        "#{Rails.root}/spec/fixtures/tariff_rates/south_korea/korea.csv").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::SouthKorea] = JSON.parse(open(
                   "#{Rails.root}/spec/fixtures/tariff_rates/south_korea/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::SouthKorea results' do
  let(:source) { TariffRate::SouthKorea }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::SouthKorea results that match "horses"' do
  let(:source) { TariffRate::SouthKorea }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::SouthKorea results that match countries "kp"' do
  let(:source) { TariffRate::SouthKorea }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::CostaRica data' do
  before(:all) do
    TariffRate::CostaRica.recreate_index
    TariffRate::CostaRicaData.new(
        "#{Rails.root}/spec/fixtures/tariff_rates/costa_rica/costa_rica.csv").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::CostaRica] = JSON.parse(open(
                   "#{Rails.root}/spec/fixtures/tariff_rates/costa_rica/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::CostaRica results' do
  let(:source) { TariffRate::CostaRica }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::CostaRica results that match "horses"' do
  let(:source) { TariffRate::CostaRica }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::CostaRica results that match countries "cr"' do
  let(:source) { TariffRate::CostaRica }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::ElSalvador data' do
  before(:all) do
    TariffRate::ElSalvador.recreate_index
    TariffRate::ElSalvadorData.new(
        "#{Rails.root}/spec/fixtures/tariff_rates/el_salvador/el_salvador.csv").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::ElSalvador] = JSON.parse(open(
                   "#{Rails.root}/spec/fixtures/tariff_rates/el_salvador/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::ElSalvador results' do
  let(:source) { TariffRate::ElSalvador }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::ElSalvador results that match "horses"' do
  let(:source) { TariffRate::ElSalvador }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::ElSalvador results that match countries "cr"' do
  let(:source) { TariffRate::ElSalvador }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::Guatemala data' do
  before(:all) do
    TariffRate::Guatemala.recreate_index
    TariffRate::GuatemalaData.new(
        "#{Rails.root}/spec/fixtures/tariff_rates/guatemala/guatemala.csv").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::Guatemala] = JSON.parse(open(
                   "#{Rails.root}/spec/fixtures/tariff_rates/guatemala/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Guatemala results' do
  let(:source) { TariffRate::Guatemala }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Guatemala results that match "horses"' do
  let(:source) { TariffRate::Guatemala }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Guatemala results that match countries "kp"' do
  let(:source) { TariffRate::Guatemala }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end
