require 'spec_helper'

describe ScreeningList::Query do
  describe '#generate_sort' do
    context 'when options include q' do
      let(:query) { described_class.new(q: 'Iran') }
      it 'does not sort' do
        expect(query.sort).to eq([])
      end
    end

    context 'when options include name and sort' do
      let(:query) { described_class.new(name: 'John Smith', sort: 'start_date') }
      it 'does not sort' do
        expect(query.sort).to eq([])
      end
    end

    context 'when options include address' do
      let(:query) { described_class.new(address: 'Iran') }
      it 'does not sort' do
        expect(query.sort).to eq([])
      end
    end

    context 'when options include only a filter' do
      let(:query) { described_class.new(countries: 'CD') }
      it 'sorts by default' do
        expect(query.sort).to eq(['name.keyword'])
      end
    end

    context 'when there are no query options' do
      let(:query) { described_class.new }
      it 'sorts by default' do
        expect(query.sort).to eq(['name.keyword'])
      end
    end

    context 'when options include sort by name' do
      let(:query) { described_class.new(countries: 'CD', sort: 'name:desc') }
      it 'sorts by param' do
        expect(query.sort).to eq(['name.keyword:desc'])
      end
    end

    context 'when options include sort by issue_date and expiration_date' do
      let(:query) { described_class.new(countries: 'CD', sort: 'issue_date:desc,expiration_date:desc') }
      it 'sorts by param' do
        expect(query.sort).to eq(['ids.issue_date:desc', 'ids.expiration_date:desc'])
      end
    end

    context 'when options include sort by start_date and end_date' do
      let(:query) { described_class.new(countries: 'CD', sort: 'start_date:asc,end_date:asc') }
      it 'sorts by param' do
        expect(query.sort).to eq(['start_date:asc', 'end_date:asc'])
      end
    end

    context 'when options include a sort on an unpermitted field' do
      let(:query) { described_class.new(sort: 'address') }
      it 'sorts by default' do
        expect(query.sort).to eq(['name.keyword'])
      end
    end
  end
end
