shared_context 'all CSL fixture data' do
  include_context 'ScreeningList::Sdn data'
  include_context 'ScreeningList::Fse data'
  include_context 'ScreeningList::El data'
  include_context 'ScreeningList::Eo13599 data'
  include_context 'ScreeningList::Dpl data'
  include_context 'ScreeningList::Uvl data'
  include_context 'ScreeningList::Isn data'
  include_context 'ScreeningList::Dtc data'
  include_context 'ScreeningList::Part561 data'
  include_context 'ScreeningList::Plc data'
  include_context 'ScreeningList::Ssi data'
end

shared_context 'ScreeningList::Part561 data' do
  before(:all) do
    ScreeningList::Part561.recreate_index
    VCR.use_cassette('importers/screening_list/part561.yml', record: :once) do
      ScreeningList::Part561Data.new(
        "#{Rails.root}/spec/fixtures/screening_lists/treasury_consolidated/consolidated.xml",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Part561] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/screening_lists/part561/expected_results.json",).read,)
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

shared_context 'ScreeningList::Sdn data' do
  before(:all) do
    ScreeningList::Sdn.recreate_index
    VCR.use_cassette('importers/screening_list/sdn.yml', record: :once) do
      ScreeningList::SdnData.new(
        "#{Rails.root}/spec/fixtures/screening_lists/sdn/sdn.xml",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Sdn] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/screening_lists/sdn/expected_results.json",).read,)
  end
end

shared_examples 'it contains all ScreeningList::Sdn results sorted by default' do
  it 'it returns the correct results' do
    results = JSON.parse(response.body)['results']
    expect(results).to eq(@all_possible_full_results[ScreeningList::Sdn])
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

shared_examples 'it contains all ScreeningList::Sdn results that match expiration_date "2010-01-01 TO 2011-01-23"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Sdn results that match issue_date "2001-12-25 TO 2002-12-31"' do
  let(:source) { ScreeningList::Sdn }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Fse data' do
  before(:all) do
    ScreeningList::Fse.recreate_index
    VCR.use_cassette('importers/screening_list/fse.yml', record: :once) do
      ScreeningList::FseData.new(
        "#{Rails.root}/spec/fixtures/screening_lists/treasury_consolidated/consolidated.xml",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Fse] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/screening_lists/fse/expected_results.json",).read,)
  end
end

shared_examples 'it contains all ScreeningList::Fse results' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [0, 1, 2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Fse results that match countries "SO"' do
  let(:source) { ScreeningList::Fse }
  let(:expected) { [1] }
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
    VCR.use_cassette('importers/screening_list/el.yml', record: :once) do
      ScreeningList::ElData.new(
        "#{Rails.root}/spec/fixtures/screening_lists/el/el.csv",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::El] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/screening_lists/el/expected_results.json",).read,)
  end
end

shared_examples 'it contains all ScreeningList::El results' do
  let(:source) { ScreeningList::El }
  let(:expected) { [0, 1, 2, 3, 4, 5, 6] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::El results that match start_date "2011-11-21"' do
  let(:source) { ScreeningList::El }
  let(:expected) { [0, 3, 4] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Eo13599 data' do
  before(:all) do
    ScreeningList::Eo13599.recreate_index
    VCR.use_cassette('importers/screening_list/eo13599.yml', record: :once) do
      ScreeningList::Eo13599Data.new(
        "#{Rails.root}/spec/fixtures/screening_lists/treasury_consolidated/consolidated.xml",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Eo13599] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/screening_lists/eo13599/expected_results.json",).read,)
  end
end

shared_examples 'it contains all ScreeningList::Eo13599 results' do
  let(:source) { ScreeningList::Eo13599 }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Eo13599 results that match "kuo"' do
  let(:source) { ScreeningList::Eo13599 }
  let(:expected) { [1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Eo13599 results that match countries "AE"' do
  let(:source) { ScreeningList::Eo13599 }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Eo13599 results that match type "Entity"' do
  let(:source) { ScreeningList::Eo13599 }
  let(:expected) { [0, 1] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Dpl data' do
  before(:all) do
    ScreeningList::Dpl.recreate_index
    VCR.use_cassette('importers/screening_list/dpl.yml', record: :once) do
      ScreeningList::DplData.new(
        "#{Rails.root}/spec/fixtures/screening_lists/dpl/dpl.txt",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Dpl] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/screening_lists/dpl/expected_results.json",).read,)
  end
end

shared_examples 'it contains all ScreeningList::Dpl results' do
  let(:source) { ScreeningList::Dpl }
  let(:expected) { [7, 1, 8, 2, 3, 6, 0, 5, 4] }
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

shared_examples 'it contains all ScreeningList::Dpl results that match end_date "2005-06-05"' do
  let(:source) { ScreeningList::Dpl }
  let(:expected) { [0] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Uvl data' do
  before(:all) do
    ScreeningList::Uvl.recreate_index
    VCR.use_cassette('importers/screening_list/uvl.yml', record: :once) do
      ScreeningList::UvlData.new(
        "#{Rails.root}/spec/fixtures/screening_lists/uvl/uvl.csv",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Uvl] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/screening_lists/uvl/expected_results.json",).read,)
  end
end

shared_examples 'it contains all ScreeningList::Uvl results' do
  let(:source) { ScreeningList::Uvl }
  let(:expected) { (0..12).to_a }
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

shared_context 'ScreeningList::Isn data' do
  before(:all) do
    ScreeningList::Isn.recreate_index
    VCR.use_cassette('importers/screening_list/isn.yml', record: :once) do
      ScreeningList::IsnData.new(
        "#{Rails.root}/spec/fixtures/screening_lists/isn/isn.csv",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Isn] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/screening_lists/isn/expected_results.json",).read,)
  end
end

shared_examples 'it contains all ScreeningList::Isn results' do
  let(:source) { ScreeningList::Isn }
  let(:expected) { (0..2).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Isn results that match countries "PK"' do
  let(:source) { ScreeningList::Isn }
  let(:expected) { [2] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Dtc data' do
  before(:all) do
    ScreeningList::Dtc.recreate_index
    VCR.use_cassette('importers/screening_list/dtc.yml', record: :once) do
      ScreeningList::DtcData.new(
        "#{Rails.root}/spec/fixtures/screening_lists/dtc/itar_debarred_parties.csv",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Dtc] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/screening_lists/dtc/expected_results.json",).read,)
  end
end

shared_examples 'it contains all ScreeningList::Dtc results' do
  let(:source) { ScreeningList::Dtc }
  let(:expected) { [0, 1, 2, 3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Plc data' do
  before(:all) do
    ScreeningList::Plc.recreate_index
    VCR.use_cassette('importers/screening_list/plc.yml', record: :once) do
      ScreeningList::PlcData.new(
        "#{Rails.root}/spec/fixtures/screening_lists/treasury_consolidated/consolidated.xml",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Plc] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/screening_lists/plc/expected_results.json",).read,)
  end
end

shared_examples 'it contains all ScreeningList::Plc results that match "SALEH, Jamal" with distance of 1' do
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

shared_examples 'it contains all ScreeningList::Plc results that match type "Individual"' do
  let(:source) { ScreeningList::Plc }
  let(:expected) { (0..5).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'ScreeningList::Ssi data' do
  before(:all) do
    ScreeningList::Ssi.recreate_index
    VCR.use_cassette('importers/screening_list/ssi.yml', record: :once) do
      ScreeningList::SsiData.new(
        "#{Rails.root}/spec/fixtures/screening_lists/treasury_consolidated/consolidated.xml",).import
    end

    @all_possible_full_results ||= {}
    @all_possible_full_results[ScreeningList::Ssi] = JSON.parse(open(
      "#{File.dirname(__FILE__)}/screening_lists/ssi/expected_results.json",).read,)
  end
end

shared_examples 'it contains all ScreeningList::Ssi results' do
  let(:source) { ScreeningList::Ssi }
  let(:expected) { (0..3).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Ssi results that match "transneft"' do
  let(:source) { ScreeningList::Ssi }
  let(:expected) { [3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ScreeningList::Ssi results that match type "Entity"' do
  let(:source) { ScreeningList::Ssi }
  let(:expected) { (0..3).to_a }
  it_behaves_like 'it contains all expected results of source'
end

shared_context 'exclude id from all possible full results' do
  before(:all) do
    @all_possible_full_results ||= {}
    @all_possible_full_results.each do |_source, results|
      results.each { |r| r.except!('id') }
    end
  end
end
