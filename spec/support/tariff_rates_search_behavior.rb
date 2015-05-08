
shared_context 'all Tariff Rates fixture data' do
  include_context 'TariffRate::Australia data'
  include_context 'TariffRate::Bahrain data'
  include_context 'TariffRate::Chile data'
  include_context 'TariffRate::Colombia data'
  include_context 'TariffRate::CostaRica data'
  include_context 'TariffRate::DominicanRepublic data'
  include_context 'TariffRate::ElSalvador data'
  include_context 'TariffRate::Guatemala data'
  include_context 'TariffRate::Honduras data'
  include_context 'TariffRate::Morocco data'
  include_context 'TariffRate::Nicaragua data'
  include_context 'TariffRate::Oman data'
  include_context 'TariffRate::Panama data'
  include_context 'TariffRate::Peru data'
  include_context 'TariffRate::Singapore data'
  include_context 'TariffRate::SouthKorea data'
end

shared_context 'TariffRate::Australia data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/australia"
    fixtures_file = "#{fixtures_dir}/australia.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::Australia.recreate_index
    TariffRate::AustraliaData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::Australia] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/australia/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Australia results' do
  let(:source) { TariffRate::Australia }
  let(:expected) { [0, 1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Australia results that match "horses"' do
  let(:source) { TariffRate::Australia }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Australia results that match countries "us,au"' do
  let(:source) { TariffRate::Australia }
  let(:expected) { [0, 1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Australia results that match final_year "2005"' do
  let(:source) { TariffRate::Australia }
  let(:expected) { [0, 1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Australia results that match partner_start_year "2005"' do
  let(:source) { TariffRate::Australia }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Australia results that match reporter_start_year "2005"' do
  let(:source) { TariffRate::Australia }
  let(:expected) { [0, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::Bahrain data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/bahrain"
    fixtures_file = "#{fixtures_dir}/bahrain.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::Bahrain.recreate_index
    TariffRate::BahrainData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::Bahrain] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/bahrain/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Bahrain results' do
  let(:source) { TariffRate::Bahrain }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Bahrain results that match "horses"' do
  let(:source) { TariffRate::Bahrain }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Bahrain results that match countries "bh"' do
  let(:source) { TariffRate::Bahrain }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::Chile data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/chile"
    fixtures_file = "#{fixtures_dir}/chile.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::Chile.recreate_index
    TariffRate::ChileData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::Chile] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/chile/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Chile results' do
  let(:source) { TariffRate::Chile }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Chile results that match "caballos"' do
  let(:source) { TariffRate::Chile }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Chile results that match countries "cl"' do
  let(:source) { TariffRate::Chile }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::Colombia data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/colombia"
    fixtures_file = "#{fixtures_dir}/colombia.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::Colombia.recreate_index
    TariffRate::ColombiaData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::Colombia] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/colombia/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Colombia results' do
  let(:source) { TariffRate::Colombia }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Colombia results that match "horses"' do
  let(:source) { TariffRate::Colombia }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Colombia results that match countries "co"' do
  let(:source) { TariffRate::Colombia }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::CostaRica data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/costa_rica"
    fixtures_file = "#{fixtures_dir}/costa_rica.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::CostaRica.recreate_index
    TariffRate::CostaRicaData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::CostaRica] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/costa_rica/expected_results.json").read)
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

shared_context 'TariffRate::DominicanRepublic data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/dominican_republic"
    fixtures_file = "#{fixtures_dir}/dominican_republic.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::DominicanRepublic.recreate_index
    TariffRate::DominicanRepublicData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::DominicanRepublic] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/dominican_republic/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::DominicanRepublic results' do
  let(:source) { TariffRate::DominicanRepublic }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::DominicanRepublic results that match "horses"' do
  let(:source) { TariffRate::DominicanRepublic }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::DominicanRepublic results that match countries "do"' do
  let(:source) { TariffRate::DominicanRepublic }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::ElSalvador data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/el_salvador"
    fixtures_file = "#{fixtures_dir}/el_salvador.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::ElSalvador.recreate_index
    TariffRate::ElSalvadorData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::ElSalvador] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/el_salvador/expected_results.json").read)
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

shared_examples 'it contains all TariffRate::ElSalvador results that match countries "sv"' do
  let(:source) { TariffRate::ElSalvador }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::Guatemala data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/guatemala"
    fixtures_file = "#{fixtures_dir}/guatemala.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::Guatemala.recreate_index
    TariffRate::GuatemalaData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::Guatemala] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/guatemala/expected_results.json").read)
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

shared_examples 'it contains all TariffRate::Guatemala results that match countries "gt"' do
  let(:source) { TariffRate::Guatemala }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::Honduras data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/honduras"
    fixtures_file = "#{fixtures_dir}/honduras.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::Honduras.recreate_index
    TariffRate::HondurasData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::Honduras] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/honduras/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Honduras results' do
  let(:source) { TariffRate::Honduras }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Honduras results that match "horses"' do
  let(:source) { TariffRate::Honduras }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Honduras results that match countries "hn"' do
  let(:source) { TariffRate::Honduras }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::Morocco data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/morocco"
    fixtures_file = "#{fixtures_dir}/morocco.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::Morocco.recreate_index
    TariffRate::MoroccoData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::Morocco] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/morocco/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Morocco results' do
  let(:source) { TariffRate::Morocco }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Morocco results that match "horses"' do
  let(:source) { TariffRate::Morocco }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Morocco results that match countries "ma"' do
  let(:source) { TariffRate::Morocco }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::Nicaragua data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/nicaragua"
    fixtures_file = "#{fixtures_dir}/nicaragua.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::Nicaragua.recreate_index
    TariffRate::NicaraguaData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::Nicaragua] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/nicaragua/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Nicaragua results' do
  let(:source) { TariffRate::Nicaragua }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Nicaragua results that match "horses"' do
  let(:source) { TariffRate::Nicaragua }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Nicaragua results that match countries "ni"' do
  let(:source) { TariffRate::Nicaragua }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::Oman data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/oman"
    fixtures_file = "#{fixtures_dir}/oman.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::Oman.recreate_index
    TariffRate::OmanData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::Oman] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/oman/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Oman results' do
  let(:source) { TariffRate::Oman }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Oman results that match "horses"' do
  let(:source) { TariffRate::Oman }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Oman results that match countries "om"' do
  let(:source) { TariffRate::Oman }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::Panama data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/panama"
    fixtures_file = "#{fixtures_dir}/panama.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::Panama.recreate_index
    TariffRate::PanamaData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::Panama] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/panama/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Panama results' do
  let(:source) { TariffRate::Panama }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Panama results that match "horses"' do
  let(:source) { TariffRate::Panama }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Panama results that match countries "pa"' do
  let(:source) { TariffRate::Panama }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::Peru data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/peru"
    fixtures_file = "#{fixtures_dir}/peru.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::Peru.recreate_index
    TariffRate::PeruData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::Peru] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/peru/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Peru results' do
  let(:source) { TariffRate::Peru }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Peru results that match "horses"' do
  let(:source) { TariffRate::Peru }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Peru results that match countries "pe"' do
  let(:source) { TariffRate::Peru }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::Singapore data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/singapore"
    fixtures_file = "#{fixtures_dir}/singapore.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::Singapore.recreate_index
    TariffRate::SingaporeData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::Singapore] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/singapore/expected_results.json").read)
  end
end

shared_examples 'it contains all TariffRate::Singapore results' do
  let(:source) { TariffRate::Singapore }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Singapore results that match "horses"' do
  let(:source) { TariffRate::Singapore }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all TariffRate::Singapore results that match countries "sg"' do
  let(:source) { TariffRate::Singapore }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'TariffRate::SouthKorea data' do
  before(:all) do
    fixtures_dir = "#{Rails.root}/spec/fixtures/tariff_rates/south_korea"
    fixtures_file = "#{fixtures_dir}/korea.csv"
    s3 = stubbed_s3_client('tariff_rate')
    s3.stub_responses(:get_object, body: open(fixtures_file).read)

    TariffRate::SouthKorea.recreate_index
    TariffRate::SouthKoreaData.new(fixtures_file, s3).import

    @all_possible_full_results ||= {}
    @all_possible_full_results[TariffRate::SouthKorea] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/tariff_rates/south_korea/expected_results.json").read)
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

shared_examples 'it contains all TariffRate::SouthKorea results that match countries "kr"' do
  let(:source) { TariffRate::SouthKorea }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

def stubbed_s3_client(importer)
  Aws::S3::Client.new(
    stub_responses: true,
    region:         Rails.configuration.send(importer)[:aws][:region],
    credentials:    Aws::Credentials.new(
      Rails.configuration.send(importer)[:aws][:region],
      Rails.configuration.send(importer)[:aws][:region]))
end
