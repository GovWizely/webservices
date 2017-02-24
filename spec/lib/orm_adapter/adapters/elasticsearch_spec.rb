require 'spec_helper'
require 'elasticsearch/persistence/model'

describe OrmAdapter::Elasticsearch do
  before do
    class ThingModel
      include Elasticsearch::Persistence::Model
      attribute :email, String, mapping: { type: 'keyword' }
    end
    ThingModel.create_index!
  end

  after do
    ThingModel.gateway.delete_index!
    Object.send(:remove_const, :ThingModel)
  end

  subject { OrmAdapter::Elasticsearch.new(ThingModel) }

  describe '#column_names' do
    it 'lists the column names' do
      expect(subject.column_names).to eq(%i(created_at updated_at email))
    end
  end

  describe '#get!?' do
    let!(:thing) { ThingModel.create(email: 'get@example.com') }
    before { ThingModel.gateway.refresh_index! }

    context 'when thing already exists' do
      it 'gets the record' do
        expect(subject.get!(thing.id).id).to eq(thing.id)
        expect(subject.get(thing.id).id).to eq(thing.id)
      end
    end

    context "when thing doesn't exist" do
      it 'gets the record' do
        expect(subject.get('abc')).to be_nil
        expect(subject.get!('abc')).to be_nil
      end
    end
  end

  describe '#find_first' do
    let!(:thing) { ThingModel.create(email: 'find_first@example.com') }
    before { ThingModel.gateway.refresh_index! }

    it 'finds an existing record' do
      expect(subject.find_first(email: thing.email).id).to eq(thing.id)
    end

    it "doesn't find anything when the search critera don't match an existing record" do
      expect(subject.find_first(foo: :bar)).to be_nil
    end
  end

  describe '#find_all' do
    let!(:thing1) { ThingModel.create(email: 'thing@example.com') }
    let!(:thing2) { ThingModel.create(email: 'thing@example.com') }
    before { ThingModel.gateway.refresh_index! }
    it 'finds both records' do
      record_emails = subject.find_all(email: 'thing@example.com').map(&:id).sort
      expect(record_emails).to eq([thing1.id, thing2.id].sort)
    end
  end

  describe '#create!' do
    it 'creates a record' do
      thing = subject.create!(email: 'create@example.com')
      ThingModel.gateway.refresh_index!
      expect(subject.get(thing.id).id).to eq(thing.id)
    end
  end

  describe '#destroy' do
    let!(:thing) { ThingModel.create(email: 'destroy@example.com') }
    it 'destroys a record' do
      ThingModel.gateway.refresh_index!
      expect(subject.destroy(thing)).to be
      ThingModel.gateway.refresh_index!
      expect(subject.get(thing.id)).to be_nil
    end
  end
end
