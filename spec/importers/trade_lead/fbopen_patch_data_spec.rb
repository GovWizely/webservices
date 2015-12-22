require 'spec_helper'

describe TradeLead::FbopenImporter::PatchData, vcr: { cassette_name: 'importers/trade_leads/fbopen/complete_source.yml', record: :once } do
  let(:resource)     { "#{Rails.root}/spec/fixtures/trade_leads/fbopen/complete_source" }
  let(:importer)     { described_class.new(resource) }
  let(:expected)     { YAML.load_file("#{File.dirname(__FILE__)}/fbopen/expected_leads.yaml") }

  it_behaves_like 'an importer which indexes the correct documents'

  describe '#model_class' do
    it 'returns correct model_class' do
      expect(importer.model_class).to match(TradeLead::Fbopen)
    end
  end

  describe '#can_purge_old?' do
    it 'always returns false' do
      expect(importer.can_purge_old?).to match(false)
    end
  end

  describe '#default_endpoint' do
    it 'returns valid endpoint url' do
      expect(URI.parse(importer.default_endpoint).scheme).to match(/ftp|http/)
    end
  end

  describe '#process_entry' do
    let(:original) do
      {
        'ntype'      => 'PRESOL',
        'CONTACT'    => 'Juanita A. Waters, Contract Administrator, Phone 7704882933, Fax N/A',
        'NAICS'      => nil,
        'YEAR'       => '13',
        'SUBJECT'    => 'National Health and Nutrition Examination Survey (NHANES) Survey',
        'DATE'       => '0616',
        'OFFADD'     => '2920 Brandywine Road, Room 3000 Atlanta GA 30341-4146',
        'AGENCY'     => 'Department of Health and Human Services',
        'ARCHDATE'   => '03142014',
        'POPADDRESS' => 'At 15 different Primary Sampling Units (PSUs) yearly.  The PSU location',
        'LOCATION'   => 'Procurement and Grants Office (Atlanta)',
        'CLASSCOD'   => 'B',
        'DESC'       => "The National Health and Nutrition Examination Survey (NHANES) is a prog.\r\n<p>The NHANES program began in the early 1960's and has been conducted as a s</p>\r\n<p>&nbsp;</p>",
        'POPCOUNTRY' => 'BR',
        'SETASIDE'   => 'N/A',
        'SOLNBR'     => '2013-N-15012',
        'LINK'       => nil,
        'OFFICE'     => 'Centers for Disease Control and Prevention',
        'ZIP'        => '30341-4146',
        'EMAIL'      => 'sample@example.net',
        'RESPDATE'   => '053014',
      }
    end

    subject { importer.__send__(:process_entry, original) }

    it 'correctly remaps data fields' do
      is_expected.to eq(classification_code:              'B',
                        competitive_procurement_strategy: 'N/A',
                        contact:                          'Juanita A. Waters, Contract Administrator, Phone 7704882933, Fax N/A',
                        contract_number:                  '2013-N-15012',
                        id:                               '2013-N-15012',
                        description:                      "The National Health and Nutrition Examination Survey (NHANES) is a prog. The NHANES program began in the early 1960's and has been conducted as a s",
                        industry:                         nil,
                        ita_industries:                   [],
                        notice_type:                      'PRESOL',
                        procurement_office:               'Centers for Disease Control and Prevention',
                        procurement_office_address:       '2920 Brandywine Road, Room 3000 Atlanta GA 30341-4146',
                        procurement_organization:         'Department of Health and Human Services',
                        procurement_organization_address: 'Procurement and Grants Office (Atlanta)',
                        publish_date:                     '2013-06-16',
                        specific_address:                 'At 15 different Primary Sampling Units (PSUs) yearly. The PSU location',
                        specific_location:                'BR',
                        title:                            'National Health and Nutrition Examination Survey (NHANES) Survey',
                        url:                              nil,
                        end_date:                         '2014-05-30',
                        source:                           'FBO',
                       )
    end

    it 'ignores US records' do
      us_record = original.dup
      us_record['POPCOUNTRY'] = 'US'
      expect(importer.__send__(:process_entry, us_record)).to be_nil
      us_record['POPCOUNTRY'] = 'USA'
      expect(importer.__send__(:process_entry, us_record)).to be_nil
    end
  end
end
