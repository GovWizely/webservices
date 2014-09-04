require 'spec_helper'

describe CanadaLeadData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/canada_leads" }
  let(:resource)     { "#{fixtures_dir}/canada_leads.csv" }
  let(:importer)     { CanadaLeadData.new(resource) }

  describe '#import' do
    it 'loads leads from specified resource' do
      CanadaLead.should_receive(:index) do |canada_leads|
        canada_leads.size.should == 5
      end
      importer.import
    end
  end

  describe "#leads" do
    let(:expected_lead_data) { YAML.load_file("#{fixtures_dir}/expected_canada_leads.yaml") }
    it 'correctly transform leads from csv' do
      canada_leads = importer.leads
      expected_lead_data.each_with_index { |expected_lead, index| canada_leads[index].should == expected_lead }
    end
  end

  describe "#process_entry" do
    let(:original) do
      { language: 'English',
        title: 'Online eICEP (6D094-132083/A)',
        reference_number: 'PW-$$ZH-113-27647',
        publication_date: '2014-05-22',
        date_closing: '2014-06-06 14:00 Eastern Daylight Time (EDT)',
        amendment_date: '2014-05-23',
        publishing_status: 'Active',
        gsin: 'G009D: Health, U006C: Technical, U099SA: Safety',
        region_opportunity: 'Canada',
        region_delivery: 'Alberta',
        notice_type: 'PAC-ACAN',
        trade_agreement: 'Agreement (AIT) Canada-Colombia (CPFTA) NA Free (NAFTA)',
        tendering_procedure: 'Generally only one firm has been invited to bid',
        competitive_procurement_strategy: 'Lowest/Lower Bid',
        non_competitive_procurement_strategy: 'Exclusive Rights',
        procurement_entity: 'Public Works & Government Services Canada',
        end_user_entity: 'Public Health Agency of Canada',
        description: "  Before awarding a Contract, \t  the government (...)  ",
        contact: "Reynolds(  ), \t (888) 000-0000",
        document: 'https://example.net/123/abc.pdf',
      }
    end

    it 'correctly remaps data fields' do
      importer.__send__(:process_entry, original).should == {
        language:                              'English',
        title:                                 'Online eICEP (6D094-132083/A)',
        reference_number:                      'PW-$$ZH-113-27647',
        publish_date:                          '2014-05-22',
        end_date:                              '2014-06-06',
        publish_date_amended:                  '2014-05-23',
        status:                                'Active',
        industry:                              'G009D: Health, U006C: Technical, U099SA: Safety',
        region_opportunity:                    'Canada',
        specific_location:                     'Alberta',
        notice_type:                           'PAC-ACAN',
        trade_agreement:                       'Agreement (AIT) Canada-Colombia (CPFTA) NA Free (NAFTA)',
        bid_type:                              'Generally only one firm has been invited to bid',
        competitive_procurement_strategy:      'Lowest/Lower Bid',
        non_competitive_procurement_strategy:  'Exclusive Rights',
        procurement_organization:              'Public Works & Government Services Canada',
        implementing_entity:                   'Public Health Agency of Canada',
        description:                           'Before awarding a Contract, the government (...)',
        contact:                               'Reynolds( ), (888) 000-0000',
        urls:                                  ['https://example.net/123/abc.pdf'],
        country:                               'CA',
      }
    end
  end

end
