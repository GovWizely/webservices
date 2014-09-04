require 'spec_helper'

describe UkTradeLeadQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/uk_trade_leads" }

  describe '#generate_search_body' do
    context 'with no arguments' do
      let(:query) { described_class.new }
      it 'generates search body with default options' do
        expect(JSON.parse(query.generate_search_body)).to eq({})
      end
    end

    context 'with all possible options given' do
      let(:query) do
        described_class.new(q: 'fish',
                            industry: 'fishing')
      end
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_all.json").read }
      it 'generates search body with queries' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end
  end

end
