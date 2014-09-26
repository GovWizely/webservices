require 'spec_helper'

describe StateTradeLeadQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/state_trade_leads" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    context 'when options include countries' do
      subject { described_class.new(countries: 'us,ca') }
      its(:countries) { should == %w(US CA) }
    end
  end

  describe '#generate_search_body' do
    context 'with no arguments' do
      let(:query) { described_class.new }
      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq({})
      end
    end

    context 'with all possible options given' do
      let(:query) do
        described_class.new(q:                 'fish',
                            countries:         'CN,FR',
                            industry:          'fishing',
                            specific_location: 'qatar')
      end
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_all.json").read }
      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end

end
