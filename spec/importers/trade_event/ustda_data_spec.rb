require 'spec_helper'

describe TradeEvent::UstdaData do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_events/ustda" }
  let(:resource)     { "#{fixtures_dir}/events.csv" }
  let(:importer)     { TradeEvent::UstdaData.new(resource) }

  describe '#import' do
    it 'loads events from specified resource' do
      TradeEvent::Ustda.should_receive(:index) do |ustda_events|
        ustda_events.size.should == 5
      end
      importer.import
    end
  end

  describe '#events' do
    let(:expected_event_data) { YAML.load_file("#{fixtures_dir}/expected_ustda_events.yaml") }
    it 'correctly transform events from csv' do
      events = importer.events
      expected_event_data.each_with_index { |expected_event, index| events[index].should == expected_event }
    end
  end

  describe '#process_entry' do
    let(:original) do
      {
        id:                 "African Leaders' Visit: Transport",
        event_name:         "African Leaders' Visit: Transport",
        start_date:         '7/30/2014',
        end_date:           '8/1/2014',
        cost:               nil,
        registration_link:  'https://example.net/register',
        registration_title: "Event: African Leaders' Visit",
        description:        "USTDA and the U.S. Department of Transportation will co-host the African Leaders' Visit: Transport for high-level delegates who have recently announced plans for significant near-term expansions in both rail and aviation infrastructure. The Visit will introduce delegates to policymakers, financiers, technical experts, and equipment and services suppliers from the U.S. aviation and rail sectors. Meetings and site visits will showcase Chicago's position as a rail and aviation hub and offer participants a chance to see a confluence of advanced transportation infrastructure.  Invited delegates include: Angola, Ethiopia, Nigeria, South Africa, Common Market for Eastern and Southern Africa (COMESA), and  the Southern African Development Community (SADC).",
        industry:           'Transportation Services',
        url:                'http://www.ustda.gov/africanleadersvisits',
        venue1:             'The Big Hall',
        city1:              'Chicago',
        state1:             'IL',
        country1:           'U.S.',
        venue2:             '',
        city2:              'Louisville',
        state2:             'KY',
        country2:           'U.S.',
        venue3:             'City Theatre',
        city3:              'Cincinnati',
        state3:             'OH',
        country3:           'U.S.',
        venue4:             nil,
        city4:              nil,
        state4:             nil,
        country4:           nil,
        venue5:             nil,
        city5:              nil,
        state5:             nil,
        country5:           nil,
        venue6:             nil,
        city6:              nil,
        state6:             nil,
        country6:           nil,
        first_name:         'Steve ',
        last_name:          'Lewis',
        post:               'U.S. Trade and Development Agency',
        person_title:       'Digital Media Manager',
        phone:              '703-875-4357',
        email:              'ALVTransport@ustda.gov',
      }
    end

    it 'correctly remaps data fields' do
      importer.__send__(:process_entry, original).should == {
        id:                 "African Leaders' Visit: Transport",
        venues:             [
          {
            country: 'US',
            state:   'IL',
            city:    'Chicago',
            venue:   'The Big Hall',
          },
          {
            country: 'US',
            state:   'KY',
            city:    'Louisville',
            venue:   '',
          },
          {
            country: 'US',
            state:   'OH',
            city:    'Cincinnati',
            venue:   'City Theatre',
          },
        ],
        registration_link:  'https://example.net/register',
        registration_title: "Event: African Leaders' Visit",
        url:                'http://www.ustda.gov/africanleadersvisits',
        event_name:         "African Leaders' Visit: Transport",
        event_type:         '',
        start_date:         '2014-07-30',
        end_date:           '2014-08-01',
        cost:               nil,
        cost_currency:      '',
        description:        "USTDA and the U.S. Department of Transportation will co-host the African Leaders' Visit: Transport for high-level delegates who have recently announced plans for significant near-term expansions in both rail and aviation infrastructure. The Visit will introduce delegates to policymakers, financiers, technical experts, and equipment and services suppliers from the U.S. aviation and rail sectors. Meetings and site visits will showcase Chicago's position as a rail and aviation hub and offer participants a chance to see a confluence of advanced transportation infrastructure. Invited delegates include: Angola, Ethiopia, Nigeria, South Africa, Common Market for Eastern and Southern Africa (COMESA), and the Southern African Development Community (SADC).",
        industries:         ['Transportation Services'],
        contacts:           [{
          first_name:   'Steve',
          last_name:    'Lewis',
          post:         'U.S. Trade and Development Agency',
          person_title: 'Digital Media Manager',
          phone:        '703-875-4357',
          email:        'ALVTransport@ustda.gov',
        }],
        source:             'USTDA',
      }
    end
  end

end
