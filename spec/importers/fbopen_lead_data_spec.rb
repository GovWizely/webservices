require 'spec_helper'

describe FbopenLeadData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/fbopen_leads" }
  let(:resource)     { "#{fixtures_dir}/example_input" }
  let(:importer)     { FbopenLeadData.new(resource) }

  describe '#import' do
    it 'loads leads from specified resource' do
      FbopenLead.should_receive(:index) do |fbo|
        fbo.size.should == 2
      end
      importer.import
    end
  end

  describe '#leads' do
    let(:expected_lead_data) { YAML.load_file("#{fixtures_dir}/expected_leads.yaml") }
    it 'correctly transform leads from dump' do
      leads = importer.leads
      expected_lead_data.each_with_index { |expected_lead, index| leads[index].should == expected_lead }
    end
  end

  describe '#default_endpoint' do
    it 'returns valid endpoint url' do
      URI.parse(importer.default_endpoint).scheme.should =~ /ftp|http/
    end
  end

  describe '#process_entry' do
    let(:original) do
      {
        'ntype'      => 'PRESOL',
        'CONTACT'    => 'Juanita A. Waters, Contract Administrator, Phone 7704882933, Fax N/A',
        'NAICS'      => '541990',
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
        'LINK'       => 'https://www.fbo.gov/spg/HHS/CDCP/PGOA/2013-N-15012/listing.html',
        'OFFICE'     => 'Centers for Disease Control and Prevention',
        'ZIP'        => '30341-4146',
        'EMAIL'      => 'sample@example.net',
        'RESPDATE'   => '053014',
      }
    end

    it 'correctly remaps data fields' do
      importer.__send__(:process_entry, original).should == {
        classification_code:              'B',
        competitive_procurement_strategy: 'N/A',
        contact:                          'Juanita A. Waters, Contract Administrator, Phone 7704882933, Fax N/A',
        contract_number:                  '2013-N-15012',
        id:                               '2013-N-15012',
        description:                      "The National Health and Nutrition Examination Survey (NHANES) is a prog. The NHANES program began in the early 1960's and has been conducted as a s",
        industry:                         '541990',
        notice_type:                      'PRESOL',
        procurement_office:               'Centers for Disease Control and Prevention',
        procurement_office_address:       '2920 Brandywine Road, Room 3000 Atlanta GA 30341-4146',
        procurement_organization:         'Department of Health and Human Services',
        procurement_organization_address: 'Procurement and Grants Office (Atlanta)',
        publish_date:                     '2013-06-16',
        specific_address:                 'At 15 different Primary Sampling Units (PSUs) yearly. The PSU location',
        specific_location:                'BR',
        title:                            'National Health and Nutrition Examination Survey (NHANES) Survey',
        url:                              'https://www.fbo.gov/spg/HHS/CDCP/PGOA/2013-N-15012/listing.html',
        end_date:                         '2014-05-30',
      }
    end

    it 'ignores US records' do
      us_record = original.dup
      us_record['POPCOUNTRY'] = 'US'
      importer.__send__(:process_entry, us_record).should.nil?
      us_record['POPCOUNTRY'] = 'USA'
      importer.__send__(:process_entry, us_record).should.nil?
    end
  end

end
