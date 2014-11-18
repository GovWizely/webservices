require 'spec_helper'

describe TradeArticleQuery do
  let(:fixtures_dir) { "#{Rails.root}/spec/fixtures/trade_articles" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    describe 'evergreen' do
      context 'when options include evergreen as true' do
        subject { TradeArticleQuery.new(evergreen: 'true') }

        describe '#evergreen' do
          subject { super().evergreen }
          it { is_expected.to be_truthy }
        end
      end
      context 'when options include evergreen as false' do
        subject { TradeArticleQuery.new(evergreen: 'false') }

        describe '#evergreen' do
          subject { super().evergreen }
          it { is_expected.to be_falsey }
        end
      end
      context 'when options exclude evergreen' do
        subject { TradeArticleQuery.new({}) }

        describe '#evergreen' do
          subject { super().evergreen }
          it { is_expected.to be_nil }
        end
      end
    end

    context 'when all options specified' do
      let(:some_date) { Date.parse('2013-10-17') }
      let(:query) do
        TradeArticleQuery.new(q: 'some term', evergreen: 'true',
                                            pub_date_start: some_date, pub_date_end: some_date,
                                            update_date_start: some_date, update_date_end: some_date,
                                            countries: 'IL, US')
      end
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_all_params.json").read }

      it 'generates search body with all params' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when dates are empty' do
      let(:some_date) { Date.parse('2013-10-17') }
      let(:query) do
        TradeArticleQuery.new(q: 'some term', evergreen: 'true',
                                            pub_date_start: '', pub_date_end: '',
                                            update_date_start: some_date, update_date_end: some_date)
      end
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_empty_pub_params.json").read }

      it 'generates search body without pub range params' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

  end
end
