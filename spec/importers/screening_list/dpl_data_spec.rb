require 'spec_helper'

describe ScreeningList::DplData, vcr: { cassette_name: 'importers/screening_list/dpl.yml' } do
  before { ScreeningList::Dpl.recreate_index }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/screening_lists/dpl/dpl.txt" }
  let(:resource) { fixtures_file }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/dpl/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'a versionable resource'
  it_behaves_like 'an importer which indexes the correct documents'

  describe '#process_grouped_rows' do
    it 'returns null when entry is empty' do
      r = importer.send(:process_grouped_rows,
                        '000abc',
                        [{ name: '', street_address: '', city: '', state: '',
                          country: '', postal_code: '', effective_date: '',
                          expiration_date: '', standard_order: '',
                          last_update: '', action: '', fr_citation: '', },],
                       )
      expect(r).to eq(nil)
    end
    it 'returns correctly mapped data when entry is not empty' do
      sample = {
        name: 'Santos Dumont', street_address: '', city: 'Guaruja', state: 'SP',
        country: 'Brazil', postal_code: '1234', effective_date: '1999-12-31',
        expiration_date: '', standard_order: '',
        last_update: '', action: '', fr_citation: '',
      }
      expected = {
        name:                    'Santos Dumont',
        name_idx:                'Santos Dumont',
        start_date:              nil,
        name_no_ws:              'SantosDumont',
        name_no_ws_rev:          'DumontSantos',
        end_date:                nil,
        standard_order:          '',
        remarks:                 '',
        name_rev:                'Dumont Santos',
        federal_register_notice: '',
        id:                      '000abc',
        source:                  { full_name: 'Denied Persons List (DPL) - Bureau of Industry and Security', code: 'DPL' },
        source_list_url:         nil,
        source_information_url:  nil,
        addresses:               [{
          address: '', city: 'Guaruja', state: 'SP', country: 'Brazil', postal_code: '1234',
        },],
      }

      r = importer.send(:process_grouped_rows, '000abc', [sample])
      expect(r).to eq(expected)
    end
  end
end
