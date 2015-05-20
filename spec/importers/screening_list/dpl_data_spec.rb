require 'spec_helper'

describe ScreeningList::DplData do
  before { ScreeningList::Dpl.recreate_index }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/screening_lists/dpl/dpl.txt" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/dpl/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads denied persons from specified resource' do
      expect(ScreeningList::Dpl).to receive(:index) do |dpl|
        expect(dpl).to eq(expected)
      end
      importer.import
    end
  end
  describe '#process_grouped_rows' do
    it 'returns null when entry is empty' do
      r = importer.send(:process_grouped_rows,
                        '000abc',
                        [{ name: '', street_address: '', city: '', state: '',
                          country: '', postal_code: '', effective_date: '',
                          expiration_date: '', standard_order: '',
                          last_update: '', action: '', fr_citation: '' }],
                       )
      expect(r).to eq(nil)
    end
    it 'returns correctly mapped data when entry is not empty' do
      sample = {
        name: 'Santos Dumont', street_address: '', city: 'Guaruja', state: 'SP',
        country: 'Brazil', postal_code: '1234', effective_date: '1999-12-31',
        expiration_date: '', standard_order: '',
        last_update: '', action: '', fr_citation: ''
      }
      expected = {
<<<<<<< HEAD
        name: 'Santos Dumont',
        name_idx: 'Santos Dumont',
        start_date: nil,
        trim_name: 'SantosDumont',
        trim_rev_name: 'DumontSantos',
        end_date: nil,
        standard_order: '',
        remarks: '',
        rev_name: 'Dumont Santos',
        federal_register_notice: '',
        id: '000abc',
        source: { full_name: 'Denied Persons List (DPL) - Bureau of Industry and Security', code: 'DPL' },
        source_list_url: 'http://www.bis.doc.gov/index.php/the-denied-persons-list',
        source_information_url: 'http://www.bis.doc.gov/index.php/policy-guidance/lists-of-parties-of-concern/denied-persons-list',
        addresses: [{
=======
        name:                    'Santos Dumont',
        name_idx:                'Santos Dumont',
        start_date:              nil,
        trim_name:               'SantosDumont',
        trim_rev_name:           'DumontSantos',
        end_date:                nil,
        standard_order:          '',
        remarks:                 '',
        rev_name:                'Dumont Santos',
        federal_register_notice: '',
        id:                      '000abc',
        source:                  { full_name: 'Denied Persons List (DPL) - Bureau of Industry and Security', code: 'DPL' },
        source_list_url:         'http://www.bis.doc.gov/index.php/the-denied-persons-list',
        source_information_url:  'http://www.bis.doc.gov/index.php/policy-guidance/lists-of-parties-of-concern/denied-persons-list',
        addresses:               [{
>>>>>>> c0fe7cc5c434ffd189c1baf209efb47506473381
          address: '', city: 'Guaruja', state: 'SP', country: 'Brazil', postal_code: '1234'
        }],
      }

      r = importer.send(:process_grouped_rows, '000abc', [sample])
      expect(r).to eq(expected)
    end
  end
end
