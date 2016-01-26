require 'spec_helper'
describe DataTypeGuesser do
  before do
    class DataTypeGuesserImplementation
      include DataTypeGuesser
    end
  end

  after { Object.send(:remove_const, :DataTypeGuesserImplementation) }

  describe '#guess_column_type_from_data' do
    context 'at least one floating point number exists' do
      it 'guesses float' do
        expect(DataTypeGuesserImplementation.new.guess_column_type_from_data([3.14, 5, nil, 6, 7, 8])).to eq('float')
      end

      context 'the largest float is so big that it is probably an identifier of some sort and not a float' do
        it 'guesses enum' do
          expect(DataTypeGuesserImplementation.new.guess_column_type_from_data([2_147_483_648.14159, 5, nil])).to eq('enum')
        end
      end
    end

    context 'no floats and mostly integers exist' do
      it 'guesses integer' do
        expect(DataTypeGuesserImplementation.new.guess_column_type_from_data([3, 5, nil, 6, 7, 8])).to eq('integer')
      end

      context 'the largest int is so big that it is probably an identifier of some sort and not an int' do
        it 'guesses enum' do
          expect(DataTypeGuesserImplementation.new.guess_column_type_from_data([2_147_483_649, 5, nil])).to eq('enum')
        end
      end
    end

    context 'no floats/ints and mostly dates exist' do
      it 'guesses date' do
        arr = [Date.parse('2015-12-30'), Date.parse('2015-12-31'), Date.parse('2016-01-01'), nil]
        expect(DataTypeGuesserImplementation.new.guess_column_type_from_data(arr)).to eq('date')
      end
    end

    context 'no floats/ints/dates and mostly strings exist' do
      context 'the average string length is pretty short' do
        it 'guesses enum' do
          arr = ['Alabama', 'New Mexico', 'Texas', 'Alaska']
          expect(DataTypeGuesserImplementation.new.guess_column_type_from_data(arr)).to eq('enum')
        end
      end

      context 'the average string length is pretty long' do
        it 'guesses string' do
          arr = ['the average string length is pretty long', 'so it is probably not part of a controlled vocabulary', 'We will call it a string', 'and analyze/index it as full text']
          expect(DataTypeGuesserImplementation.new.guess_column_type_from_data(arr)).to eq('string')
        end
      end
    end

    context 'mixed strings and numerics' do
      it 'guesses enum' do
        arr = ['Alabama', 5, 'Texas', 1.4]
        expect(DataTypeGuesserImplementation.new.guess_column_type_from_data(arr)).to eq('enum')
      end
    end
  end
end
