shared_context 'all CSL fixture data' do
  include_context 'SDN data'
  include_context 'FSE data'
  include_context 'EL data'
  include_context 'DPL data'
  include_context 'UVL data'
  include_context 'ISN data'
  include_context 'DTC data'
  include_context 'PLC data'
  include_context 'SSI data'
end

shared_context 'SDN data' do
  before(:all) do
    ScreeningList::Sdn.recreate_index
    ScreeningList::SdnData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/sdn/sdn.xml").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:SDN] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/sdn/expected_results.json").read)
  end
end

shared_examples 'it contains all SDN results' do
  let(:source) { :SDN }
  let(:expected) { [1, 0, 2, 3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match "cuba"' do
  let(:source) { :SDN }
  let(:expected) { [1, 0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match "banco"' do
  let(:source) { :SDN }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match "jumali"' do
  let(:source) { :SDN }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match "havana"' do
  let(:source) { :SDN }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match "djiboutian"' do
  let(:source) { :SDN }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match countries "CH"' do
  let(:source) { :SDN }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match countries "DE"' do
  let(:source) { :SDN }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match countries "FR"' do
  let(:source) { :SDN }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match countries "BE"' do
  let(:source) { :SDN }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match countries "SO,JP"' do
  let(:source) { :SDN }
  let(:expected) { [0, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match type "Entity"' do
  let(:source) { :SDN }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match type "Vessel"' do
  let(:source) { :SDN }
  let(:expected) { [3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match type "Individual"' do
  let(:source) { :SDN }
  let(:expected) { [1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'FSE data' do
  before(:all) do
    ScreeningList::Fse.recreate_index
    ScreeningList::FseData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/fse/fse.xml").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:FSE] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/fse/expected_results.json").read)
  end
end

shared_examples 'it contains all FSE results' do
  let(:source) { :FSE }
  let(:expected) { [0, 1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match "ferland"' do
  let(:source) { :FSE }
  let(:expected) { [0, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match "vitaly"' do
  let(:source) { :FSE }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match "shahali"' do
  let(:source) { :FSE }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match "manager"' do
  let(:source) { :FSE }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match "tanker"' do
  let(:source) { :FSE }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match countries "CY"' do
  let(:source) { :FSE }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match countries "SO"' do
  let(:source) { :FSE }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match countries "IR"' do
  let(:source) { :FSE }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match countries "DJ"' do
  let(:source) { :FSE }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match countries "UA,DJ"' do
  let(:source) { :FSE }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match type "Entity"' do
  let(:source) { :FSE }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match type "Individual"' do
  let(:source) { :FSE }
  let(:expected) { [1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'EL data' do
  before(:all) do
    ScreeningList::El.recreate_index
    ScreeningList::ElData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/el/el.csv").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:EL] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/el/expected_results.json").read)
  end
end

shared_examples 'it contains all EL results' do
  let(:source) { :EL }
  let(:expected) { [0, 1, 2, 3, 4, 5, 6] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all EL results that match "fazel"' do
  let(:source) { :EL }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all EL results that match "constructions"' do
  let(:source) { :EL }
  let(:expected) { [1, 6] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all EL results that match "farid"' do
  let(:source) { :EL }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all EL results that match countries "AF"' do
  let(:source) { :EL }
  let(:expected) { [0, 1, 3, 4, 5, 6] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all EL results that match countries "AF,TR"' do
  let(:source) { :EL }
  let(:expected) { [0, 1, 2, 3, 4, 5, 6] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'DPL data' do
  before(:all) do
    ScreeningList::Dpl.recreate_index
    ScreeningList::DplData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/dpl/dpl.txt").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:DPL] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/dpl/expected_results.json").read)
  end
end

shared_examples 'it contains all DPL results' do
  let(:source) { :DPL }
  let(:expected) { [7, 1, 8, 2, 3, 6, 0, 5, 4] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DPL results that match "katsuta"' do
  let(:source) { :DPL }
  let(:expected) { [6] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DPL results that match "agnese"' do
  let(:source) { :DPL }
  let(:expected) { [4] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DPL results that match "corrected"' do
  let(:source) { :DPL }
  let(:expected) { [5, 7] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DPL results that match countries "ZA"' do
  let(:source) { :DPL }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DPL results that match countries "FR"' do
  let(:source) { :DPL }
  let(:expected) { [4] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DPL results that match countries "JP"' do
  let(:source) { :DPL }
  let(:expected) { [6] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DPL results that match countries "FR,DE"' do
  let(:source) { :DPL }
  let(:expected) { [3, 4] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'UVL data' do
  before(:all) do
    ScreeningList::Uvl.recreate_index
    ScreeningList::UvlData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/uvl/uvl.csv").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:UVL] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/uvl/expected_results.json").read)
  end
end

shared_examples 'it contains all UVL results' do
  let(:source) { :UVL }
  let(:expected) { (0..11).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all UVL results that match "technology", sorted correctly' do
  include_context 'full results from response'
  let(:source) { :UVL }
  let(:expected) { [1, 4] }

  it 'contains them all, sorted correctly' do
    expect(got).to eq(expected)
  end
end

shared_examples 'it contains all UVL results that match "brilliance"' do
  let(:source) { :UVL }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all UVL results that match countries "CN"' do
  let(:source) { :UVL }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all UVL results that match countries "HK,CN"' do
  let(:source) { :UVL }
  let(:expected) { (1..7).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ISN data' do
  before(:all) do
    ScreeningList::Isn.recreate_index
    ScreeningList::IsnData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/isn/isn.csv").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:ISN] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/isn/expected_results.json").read)
  end
end

shared_examples 'it contains all ISN results' do
  let(:source) { :ISN }
  let(:expected) { (0..4).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ISN results that match "ahmad"' do
  let(:source) { :ISN }
  let(:expected) { [3, 4] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ISN results that match "aerospace"' do
  let(:source) { :ISN }
  let(:expected) { [1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'DTC data' do
  before(:all) do
    ScreeningList::Dtc.recreate_index
    ScreeningList::DtcData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/dtc/itar_debarred_parties.csv").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:DTC] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/dtc/expected_results.json").read)
  end
end

shared_examples 'it contains all DTC results' do
  let(:source) { :DTC }
  let(:expected) { [0, 1, 2, 3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DTC results that match "brian"' do
  let(:source) { :DTC }
  let(:expected) { [0, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DTC results that match "john"' do
  let(:source) { :DTC }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DTC results that match "mcsulla"' do
  let(:source) { :DTC }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'PLC data' do
  before(:all) do
    ScreeningList::Plc.recreate_index
    ScreeningList::PlcData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/plc/ns_plc.xml").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:PLC] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/plc/expected_results.json").read)
  end
end

shared_examples 'it contains all PLC results' do
  let(:source) { :PLC }
  let(:expected) { (0..5).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all PLC results that match "heBron"' do
  let(:source) { :PLC }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all PLC results that match countries "PS"' do
  let(:source) { :PLC }
  let(:expected) { [5] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all PLC results that match type "Individual"' do
  let(:source) { :PLC }
  let(:expected) { (0..5).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'SSI data' do
  before(:all) do
    ScreeningList::Ssi.recreate_index
    ScreeningList::SsiData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/ssi/ssi.xml").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[:SSI] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/ssi/expected_results.json").read)
  end
end

shared_examples 'it contains all SSI results' do
  let(:source) { :SSI }
  let(:expected) { (0..3).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SSI results that match "transneft"' do
  let(:source) { :SSI }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SSI results that match countries "RU"' do
  let(:source) { :SSI }
  let(:expected) { (0..3).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SSI results that match countries "UA,DJ"' do
  let(:source) { :SSI }
  let(:expected) { [] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SSI results that match type "Entity"' do
  let(:source) { :SSI }
  let(:expected) { (0..3).to_a }
  it_behaves_like 'it contains all expected results of source'
end
