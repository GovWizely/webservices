require 'spec_helper'

describe ScreeningList::Mappable do
  after do
    Object.send(:remove_const, :Mock)
  end

  describe 'error checks done by .prepended' do
    context 'when class has not been extended by Model::CanDeleteOldDocuments' do
      it 'prevents inclusion' do
        expect do
          class Mock
            include ScreeningList::Mappable
          end
        end.to raise_error 'Must extend Model::CanDeleteOldDocuments'
      end
    end

    context 'with all pre-requisites met' do
      it 'allows inclusion' do
        expect do
          class Mock
            extend Indexable
            extend Model::CanDeleteOldDocuments
            include ScreeningList::Mappable
          end
        end.not_to raise_error
      end
    end
  end
end
