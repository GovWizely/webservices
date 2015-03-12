shared_context 'all CSL fixture data' do
  include_context 'ScreeningList::Sdn data'
  include_context 'ScreeningList::Fse data'
  include_context 'ScreeningList::El data'
  include_context 'ScreeningList::Dpl data'
  include_context 'ScreeningList::Uvl data'
  include_context 'ScreeningList::Isa data'
  include_context 'ScreeningList::Isn data'
  include_context 'ScreeningList::Dtc data'
  include_context 'ScreeningList::Part561 data'
  include_context 'ScreeningList::Plc data'
  include_context 'ScreeningList::Ssi data'
end

shared_context 'ScreeningList::Part561 data' do
  before(:all) do
    ScreeningList::Part561.recreate_index
    ScreeningList::Part561Data.new(
      "#{Rails.root}/spec/fixtures/screening_lists/treasury_consolidated/consolidated.xml").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Part561] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/part561/expected_results.json").read)
  end
end

shared_examples 'it contains all ScreeningList::Part561 results' do
  let(:source) { ScreeningList::Part561 }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Part561 results that match "kunlun"' do
  let(:source) { ScreeningList::Part561 }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Part561 results that match countries "CN"' do
  let(:source) { ScreeningList::Part561 }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Part561 results that match type "Entity"' do
  let(:source) { ScreeningList::Part561 }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Isa data' do
  before(:all) do
    ScreeningList::Isa.recreate_index
    ScreeningList::IsaData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/treasury_consolidated/consolidated.xml").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Isa] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/isa/expected_results.json").read)
  end
end

shared_examples 'it contains all ScreeningList::Isa results' do
  let(:source) { ScreeningList::Isa }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Isa results that match "kuo"' do
  let(:source) { ScreeningList::Isa }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Isa results that match countries "AE"' do
  let(:source) { ScreeningList::Isa }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Isa results that match type "Entity"' do
  let(:source) { ScreeningList::Isa }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Sdn data' do
  before(:all) do
    ScreeningList::Sdn.recreate_index
    ScreeningList::SdnData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/sdn/sdn.xml").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Sdn] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/sdn/expected_results.json").read)
  end
end

shared_examples 'it contains all ScreeningList::Sdn results' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [1, 0, 2, 3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Sdn results that match "cuba"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [1, 0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Sdn results that match "banco nacional de cuba"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Sdn results that match "jumali"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Sdn results that match "havana"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Sdn results that match "djiboutian"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Sdn results that match countries "CH"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Sdn results that match countries "DE"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Sdn results that match countries "FR"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Sdn results that match countries "BE"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Sdn results that match countries "SO,JP"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [0, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Sdn results that match type "Entity"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Sdn results that match type "Vessel"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Sdn results that match type "Individual"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Fse data' do
  before(:all) do
    ScreeningList::Fse.recreate_index
    ScreeningList::FseData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/treasury_consolidated/consolidated.xml").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Fse] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/fse/expected_results.json").read)
  end
end

shared_examples 'it contains all ScreeningList::Fse results' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [0, 1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Fse results that match "ferland"' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [0, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Fse results that match "vitaly"' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Fse results that match "shahali"' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Fse results that match "manager"' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Fse results that match "tanker"' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Fse results that match countries "CY"' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Fse results that match countries "SO"' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Fse results that match countries "IR"' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Fse results that match countries "DJ"' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Fse results that match countries "UA,DJ"' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Fse results that match type "Entity"' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Fse results that match type "Individual"' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::El data' do
  before(:all) do
    ScreeningList::El.recreate_index
    ScreeningList::ElData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/el/el.csv").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::El] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/el/expected_results.json").read)
  end
end

shared_examples 'it contains all ScreeningList::El results' do
  let(:source) { ScreeningList::El }
  let(:expected) { [0, 1, 2, 3, 4, 5, 6] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::El results that match "fazel"' do
  let(:source) { ScreeningList::El }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::El results that match "construction"' do
  let(:source) { ScreeningList::El }
  let(:expected) { [1, 6] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::El results that match "farid"' do
  let(:source) { ScreeningList::El }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::El results that match countries "AF"' do
  let(:source) { ScreeningList::El }
  let(:expected) { [0, 1, 3, 4, 5, 6] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::El results that match countries "AF,TR"' do
  let(:source) { ScreeningList::El }
  let(:expected) { [0, 1, 2, 3, 4, 5, 6] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Dpl data' do
  before(:all) do
    ScreeningList::Dpl.recreate_index
    ScreeningList::DplData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/dpl/dpl.txt").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Dpl] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/dpl/expected_results.json").read)
  end
end

shared_examples 'it contains all ScreeningList::Dpl results' do
  let(:source) { ScreeningList::Dpl }
  let(:expected) { [7, 1, 8, 2, 3, 6, 0, 5, 4] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Dpl results that match "katsuta"' do
  let(:source) { ScreeningList::Dpl }
  let(:expected) { [6] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Dpl results with address "MINATOKU"' do
  let(:source) { ScreeningList::Dpl }
  let(:expected) { [6] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Dpl results that match "agnese"' do
  let(:source) { ScreeningList::Dpl }
  let(:expected) { [4] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Dpl results that match "corrected"' do
  let(:source) { ScreeningList::Dpl }
  let(:expected) { [5, 7] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Dpl results that match countries "ZA"' do
  let(:source) { ScreeningList::Dpl }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Dpl results that match countries "FR"' do
  let(:source) { ScreeningList::Dpl }
  let(:expected) { [4] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Dpl results that match countries "JP"' do
  let(:source) { ScreeningList::Dpl }
  let(:expected) { [6] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Dpl results that match countries "FR,DE"' do
  let(:source) { ScreeningList::Dpl }
  let(:expected) { [3, 4] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Uvl data' do
  before(:all) do
    ScreeningList::Uvl.recreate_index
    ScreeningList::UvlData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/uvl/uvl.csv").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Uvl] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/uvl/expected_results.json").read)
  end
end

shared_examples 'it contains all ScreeningList::Uvl results' do
  let(:source) { ScreeningList::Uvl }
  let(:expected) { (0..11).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Uvl results that match "technology", sorted correctly' do
  include_context 'full results from response'
  let(:source) { ScreeningList::Uvl }
  let(:expected) { [1, 4] }

  it 'contains them all, sorted correctly' do
    expect(got).to eq(expected)
  end
end

shared_examples 'it contains all ScreeningList::Uvl results that match "brilliance"' do
  let(:source) { ScreeningList::Uvl }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Uvl results that match countries "CN"' do
  let(:source) { ScreeningList::Uvl }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Uvl results that match countries "HK,CN"' do
  let(:source) { ScreeningList::Uvl }
  let(:expected) { (1..7).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Isn data' do
  before(:all) do
    ScreeningList::Isn.recreate_index
    ScreeningList::IsnData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/isn/isn.csv").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Isn] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/isn/expected_results.json").read)
  end
end

shared_examples 'it contains all ScreeningList::Isn results' do
  let(:source) { ScreeningList::Isn }
  let(:expected) { (0..4).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Isn results that match "ahmad"' do
  let(:source) { ScreeningList::Isn }
  let(:expected) { [3, 4] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Isn results that match "aerospace"' do
  let(:source) { ScreeningList::Isn }
  let(:expected) { [1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Dtc data' do
  before(:all) do
    ScreeningList::Dtc.recreate_index
    ScreeningList::DtcData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/dtc/itar_debarred_parties.csv").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Dtc] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/dtc/expected_results.json").read)
  end
end

shared_examples 'it contains all ScreeningList::Dtc results' do
  let(:source) { ScreeningList::Dtc }
  let(:expected) { [0, 1, 2, 3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Dtc results that match "brian"' do
  let(:source) { ScreeningList::Dtc }
  let(:expected) { [0, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Dtc results that match "john"' do
  let(:source) { ScreeningList::Dtc }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Dtc results that match "mcsulla"' do
  let(:source) { ScreeningList::Dtc }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Plc data' do
  before(:all) do
    ScreeningList::Plc.recreate_index
    ScreeningList::PlcData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/treasury_consolidated/consolidated.xml").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Plc] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/plc/expected_results.json").read)
  end
end

shared_examples 'it contains all ScreeningList::Plc results that match "SALEH, Jamal" with fuzziness of 1' do
  let(:source) { ScreeningList::Plc }
  let(:expected) { [3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Plc results' do
  let(:source) { ScreeningList::Plc }
  let(:expected) { (0..5).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Plc results that match "heBron"' do
  let(:source) { ScreeningList::Plc }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Plc results that match countries "PS"' do
  let(:source) { ScreeningList::Plc }
  let(:expected) { [5] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Plc results that match type "Individual"' do
  let(:source) { ScreeningList::Plc }
  let(:expected) { (0..5).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Ssi data' do
  before(:all) do
    ScreeningList::Ssi.recreate_index
    ScreeningList::SsiData.new(
      "#{Rails.root}/spec/fixtures/screening_lists/treasury_consolidated/consolidated.xml").import

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Ssi] = JSON.parse(open(
      "#{Rails.root}/spec/fixtures/screening_lists/ssi/expected_results.json").read)
  end
end

shared_examples 'it contains all ScreeningList::Ssi results' do
  let(:source) { ScreeningList::Ssi }
  let(:expected) { (0..3).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Ssi results that match "transneft"' do
  let(:source) { ScreeningList::Ssi }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Ssi results that match countries "RU"' do
  let(:source) { ScreeningList::Ssi }
  let(:expected) { (0..3).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Ssi results that match countries "UA,DJ"' do
  let(:source) { ScreeningList::Ssi }
  let(:expected) { [] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Ssi results that match type "Entity"' do
  let(:source) { ScreeningList::Ssi }
  let(:expected) { (0..3).to_a }
  it_behaves_like 'it contains all expected results of source'
end
