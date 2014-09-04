shared_context 'all CSL fixture data' do
  include_context 'SDN data'
  include_context 'FSE data'
  include_context 'EL data'
  include_context 'DPL data'
  include_context 'UVL data'
  include_context 'ISN data'
  include_context 'DTC data'
end


shared_context 'SDN data' do
  before(:all) do
    OfacSpecialDesignatedNational.recreate_index
    OfacSpecialDesignatedNationalData.new(
      "#{Rails.root}/spec/fixtures/ofac_special_designated_nationals/sdn.xml").import
  end

  let(:all_sdn_results) do
    JSON.parse(open(
      "#{Rails.root}/spec/fixtures/ofac_special_designated_nationals/expected_results.json").read)
  end
end

shared_examples 'it contains all SDN results' do
  let(:source) { 'SDN' }
  let(:expected) { all_sdn_results }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match "cuba"' do
  let(:source) { 'SDN' }
  let(:expected) { [all_sdn_results[0], all_sdn_results[1]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match "banco"' do
  let(:source) { 'SDN' }
  let(:expected) { [all_sdn_results[0]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match "jumali"' do
  let(:source) { 'SDN' }
  let(:expected) { [all_sdn_results[2]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match "havana"' do
  let(:source) { 'SDN' }
  let(:expected) { [all_sdn_results[1]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match "djiboutian"' do
  let(:source) { 'SDN' }
  let(:expected) { [all_sdn_results[2]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match countries "CH"' do
  let(:source) { 'SDN' }
  let(:expected) { [all_sdn_results[0]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match countries "DE"' do
  let(:source) { 'SDN' }
  let(:expected) { [all_sdn_results[1]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match countries "FR"' do
  let(:source) { 'SDN' }
  let(:expected) { [all_sdn_results[1]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match countries "BE"' do
  let(:source) { 'SDN' }
  let(:expected) { [all_sdn_results[1]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match countries "SO,JP"' do
  let(:source) { 'SDN' }
  let(:expected) { [all_sdn_results[0], all_sdn_results[2]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match sdn_type "Entity"' do
  let(:source) { 'SDN' }
  let(:expected) { [all_sdn_results[0]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match sdn_type "Vessel"' do
  let(:source) { 'SDN' }
  let(:expected) { [all_sdn_results[3]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all SDN results that match sdn_type "Individual"' do
  let(:source) { 'SDN' }
  let(:expected) { [all_sdn_results[1], all_sdn_results[2]] }
  it_behaves_like 'it contains all expected results of source'
end


shared_context 'FSE data' do
  before(:all) do
    BisnForeignSanctionsEvader.recreate_index
    BisnForeignSanctionsEvaderData.new(
      "#{Rails.root}/spec/fixtures/bisn_foreign_sanctions_evaders/fse.xml").import
  end

  let(:all_fse_results) do
    JSON.parse(open(
      "#{Rails.root}/spec/fixtures/bisn_foreign_sanctions_evaders/expected_results.json").read)
  end
end

shared_examples 'it contains all FSE results' do
  let(:source) { 'FSE' }
  let(:expected) { all_fse_results }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match "ferland"' do
  let(:source) { 'FSE' }
  let(:expected) { [all_fse_results[0], all_fse_results[1]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match "vitaly"' do
  let(:source) { 'FSE' }
  let(:expected) { [all_fse_results[1]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match "shahali"' do
  let(:source) { 'FSE' }
  let(:expected) { [all_fse_results[2]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match "manager"' do
  let(:source) { 'FSE' }
  let(:expected) { [all_fse_results[1]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match "tanker"' do
  let(:source) { 'FSE' }
  let(:expected) { [all_fse_results[0]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match countries "CY"' do
  let(:source) { 'FSE' }
  let(:expected) { [all_fse_results[0]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match countries "SO"' do
  let(:source) { 'FSE' }
  let(:expected) { [all_fse_results[2]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match countries "IR"' do
  let(:source) { 'FSE' }
  let(:expected) { [all_fse_results[2]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match countries "DJ"' do
  let(:source) { 'FSE' }
  let(:expected) { [all_fse_results[2]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match countries "UA,DJ"' do
  let(:source) { 'FSE' }
  let(:expected) { [all_fse_results[0], all_fse_results[2]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match sdn_type "Entity"' do
  let(:source) { 'FSE' }
  let(:expected) { [all_fse_results[0]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all FSE results that match sdn_type "Individual"' do
  let(:source) { 'FSE' }
  let(:expected) { [all_fse_results[1], all_fse_results[2]] }
  it_behaves_like 'it contains all expected results of source'
end


shared_context 'EL data' do
  before(:all) do
    BisEntity.recreate_index
    BisEntityData.new(
      "#{Rails.root}/spec/fixtures/bis_entities/el.csv").import
  end

  let(:all_el_results) do
    JSON.parse(open(
      "#{Rails.root}/spec/fixtures/bis_entities/expected_results.json").read)
  end
end

shared_examples 'it contains all EL results' do
  let(:source) { 'EL' }
  let(:expected) { all_el_results }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all EL results that match "fazel"' do
  let(:source) { 'EL' }
  let(:expected) { [all_el_results[1], all_el_results[0]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all EL results that match "constructions"' do
  let(:source) { 'EL' }
  let(:expected) { [all_el_results[1], all_el_results[2]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all EL results that match "farid"' do
  let(:source) { 'EL' }
  let(:expected) { [all_el_results[0]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all EL results that match countries "AF"' do
  let(:source) { 'EL' }
  let(:expected) { all_el_results[0..3] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all EL results that match countries "AF,TR"' do
  let(:source) { 'EL' }
  let(:expected) { all_el_results }
  it_behaves_like 'it contains all expected results of source'
end


shared_context 'DPL data' do
  before(:all) do
    BisDeniedPerson.recreate_index
    BisDeniedPersonData.new(
      "#{Rails.root}/spec/fixtures/bis_denied_people/dpl.txt").import
  end

  let(:all_dpl_results) do
    JSON.parse(open(
      "#{Rails.root}/spec/fixtures/bis_denied_people/expected_results.json").read)
  end
end

shared_examples 'it contains all DPL results' do
  let(:source) { 'DPL' }
  let(:expected) { all_dpl_results }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DPL results that match "katsuta"' do
  let(:source) { 'DPL' }
  let(:expected) { [all_dpl_results[0]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DPL results that match "agnese"' do
  let(:source) { 'DPL' }
  let(:expected) { [all_dpl_results[3]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DPL results that match "corrected"' do
  let(:source) { 'DPL' }
  let(:expected) { [all_dpl_results[5], all_dpl_results[6]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DPL results that match countries "ZA"' do
  let(:source) { 'DPL' }
  let(:expected) { [all_dpl_results[8]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DPL results that match countries "FR"' do
  let(:source) { 'DPL' }
  let(:expected) { [all_dpl_results[3]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DPL results that match countries "JP"' do
  let(:source) { 'DPL' }
  let(:expected) { [all_dpl_results[0]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DPL results that match countries "FR,DE"' do
  let(:source) { 'DPL' }
  let(:expected) { [all_dpl_results[2], all_dpl_results[3]] }
  it_behaves_like 'it contains all expected results of source'
end


shared_context 'UVL data' do
  before(:all) do
    BisUnverifiedParty.recreate_index
    BisUnverifiedPartyData.new(
      "#{Rails.root}/spec/fixtures/bis_unverified_parties/uvl.csv").import
  end

  let(:all_uvl_results) do
    JSON.parse(open(
      "#{Rails.root}/spec/fixtures/bis_unverified_parties/expected_results.json").read)
  end
end

shared_examples 'it contains all UVL results' do
  let(:source) { 'UVL' }
  let(:expected) { all_uvl_results }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all UVL results that match "technology"' do
  let(:source) { 'UVL' }
  let(:expected) { [all_uvl_results[2], all_uvl_results[5]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all UVL results that match "brilliance"' do
  let(:source) { 'UVL' }
  let(:expected) { [all_uvl_results[5]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all UVL results that match countries "CN"' do
  let(:source) { 'UVL' }
  let(:expected) { [all_uvl_results[1]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all UVL results that match countries "HK,CN"' do
  let(:source) { 'UVL' }
  let(:expected) { all_uvl_results[0..3] + all_uvl_results[5..6] }
  it_behaves_like 'it contains all expected results of source'
end


shared_context 'ISN data' do
  before(:all) do
    BisnNonproliferationSanction.recreate_index
    BisnNonproliferationSanctionData.new(
      "#{Rails.root}/spec/fixtures/bisn_nonproliferation_sanctions/isn.csv").import
  end

  let(:all_isn_results) do
    JSON.parse(open(
      "#{Rails.root}/spec/fixtures/bisn_nonproliferation_sanctions/expected_results.json").read)
  end
end

shared_examples 'it contains all ISN results' do
  let(:source) { 'ISN' }
  let(:expected) { all_isn_results }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ISN results that match "ahmad"' do
  let(:source) { 'ISN' }
  let(:expected) { [all_isn_results[3], all_isn_results[4]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all ISN results that match "aerospace"' do
  let(:source) { 'ISN' }
  let(:expected) { [all_isn_results[1], all_isn_results[2]] }
  it_behaves_like 'it contains all expected results of source'
end


shared_context 'DTC data' do
  before(:all) do
    DdtcAecaDebarredParty.recreate_index
    DdtcAecaDebarredPartyData.new(
      "#{Rails.root}/spec/fixtures/ddtc_aeca_debarred_parties/aeca_debarred_parties.csv").import
  end

  let(:all_dtc_results) do
    JSON.parse(open(
      "#{Rails.root}/spec/fixtures/ddtc_aeca_debarred_parties/expected_results.json").read)
  end
end

shared_examples 'it contains all DTC results' do
  let(:source) { 'DTC' }
  let(:expected) { all_dtc_results }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DTC results that match "brian"' do
  let(:source) { 'DTC' }
  let(:expected) { [all_dtc_results[1], all_dtc_results[2]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DTC results that match "john"' do
  let(:source) { 'DTC' }
  let(:expected) { [all_dtc_results[1]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DTC results that match "mcsulla"' do
  let(:source) { 'DTC' }
  let(:expected) { [all_dtc_results[2]] }
  it_behaves_like 'it contains all expected results of source'
end

shared_examples 'it contains all DTC results that match "original"' do
  let(:source) { 'DTC' }
  let(:expected) { [all_dtc_results[1]] }
  it_behaves_like 'it contains all expected results of source'
end


shared_examples 'it contains all expected results of source' do
  let(:results) do
    JSON.parse(response.body)['results']
      .find_all { |r| r['source'] == source }
  end

  it 'contains them all' do
    expected.should match_array(results)
  end
end

shared_examples 'it contains only results with sources' do
  let(:results) { JSON.parse(response.body)['results'] }
  let(:results_with_source_other_than_expected) do
    results.find_all { |r| !sources.include?(r['source']) }
  end
  it 'contains only results with sources' do
    expect(results_with_source_other_than_expected.length).to eq 0
  end
end
