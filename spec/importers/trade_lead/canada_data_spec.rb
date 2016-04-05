require 'spec_helper'

describe TradeLead::CanadaData, vcr: { cassette_name: 'importers/trade_leads/canada.yml', record: :once } do
  include_context 'ItaTaxonomy data'

  let(:resource)     { "#{Rails.root}/spec/fixtures/trade_leads/canada/canada_leads.csv" }
  let(:importer)     { described_class.new(resource) }
  let(:expected)     { YAML.load_file("#{File.dirname(__FILE__)}/canada/expected_canada_leads.yaml") }

  it_behaves_like 'an importer which can purge old documents'
  it_behaves_like 'an importer which indexes the correct documents'
  it_behaves_like 'a versionable resource'

  describe '#process_entry' do
    let(:original) do
      { language:                             'English',
        title:                                'Online eICEP (6D094-132083/A)',
        reference_number:                     'PW-$$ZH-113-27647',
        publication_date:                     '2014-05-22',
        date_closing:                         '2014-06-06 14:00 Eastern Daylight Time (EDT)',
        amendment_date:                       '2014-05-23',
        publishing_status:                    'Active',
        gsin:                                 nil,
        region_opportunity:                   'Canada',
        region_delivery:                      'Alberta',
        notice_type:                          'PAC-ACAN',
        trade_agreement:                      'Agreement (AIT) Canada-Colombia (CPFTA) NA Free (NAFTA)',
        tendering_procedure:                  'Generally only one firm has been invited to bid',
        competitive_procurement_strategy:     'Lowest/Lower Bid',
        non_competitive_procurement_strategy: 'Exclusive Rights',
        procurement_entity:                   'Public Works & Government Services Canada',
        end_user_entity:                      'Public Health Agency of Canada',
        description:                          "  Before awarding a Contract, \t  the government (...)  ",
        contact:                              "Reynolds(  ), \t (888) 000-0000",
        document:                             nil,
      }
    end

    subject { importer.__send__(:process_entry, original) }

    it 'correctly remaps data fields' do
      is_expected.to eq(language:                             'English',
                        title:                                'Online eICEP (6D094-132083/A)',
                        reference_number:                     'PW-$$ZH-113-27647',
                        publish_date:                         '2014-05-22',
                        end_date:                             '2014-06-06',
                        publish_date_amended:                 '2014-05-23',
                        status:                               'Active',
                        industry:                             nil,
                        ita_industries:                       [],
                        region_opportunity:                   'Canada',
                        specific_location:                    'Alberta',
                        notice_type:                          'PAC-ACAN',
                        trade_agreement:                      'Agreement (AIT) Canada-Colombia (CPFTA) NA Free (NAFTA)',
                        bid_type:                             'Generally only one firm has been invited to bid',
                        competitive_procurement_strategy:     'Lowest/Lower Bid',
                        non_competitive_procurement_strategy: 'Exclusive Rights',
                        procurement_organization:             'Public Works & Government Services Canada',
                        implementing_entity:                  'Public Health Agency of Canada',
                        description:                          'Before awarding a Contract, the government (...)',
                        contact:                              'Reynolds( ), (888) 000-0000',
                        urls:                                 nil,
                        country:                              'CA',
                        country_name:                         'Canada',
                        trade_regions:                        ['NAFTA', 'Trans Pacific Partnership', 'Asia Pacific Economic Cooperation'],
                        world_regions:                        ['North America', 'Pacific Rim', 'Western Hemisphere'],
                        source:                               'CANADA',
                       )
    end
  end
end
