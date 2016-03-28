require 'spec_helper'

describe SeparatedValuesable do
  describe '#as_csv' do
    context 'with no nested documents' do
      before do
        class NoNestedExample
          include SeparatedValuesable
          self.separated_values_config = [:foo, :bar]
        end
      end

      after { Object.send(:remove_const, :NoNestedExample) }

      let(:search_results) do
        [{ _source: { foo: 'One', bar: 'Satu', baz: 'eins' } },
         { _source: { foo: 'Two', bar: 'Dua',  baz: 'zwie' } },]
      end

      subject { NoNestedExample.as_csv(search_results) }

      it { is_expected.to eq(body_of('no_nested.csv')) }
    end

    context 'with field containing array of nested documents' do
      before do
        class ArrayFieldExample
          include SeparatedValuesable
          self.separated_values_config = [:foo, :bar]
        end
      end

      after { Object.send(:remove_const, :ArrayFieldExample) }

      let(:search_results) do
        [{ _source: { foo: 'One', bar: ['Satu', 1], baz: 'eins' } },
         { _source: { foo: 'Two', bar: ['Dua', 2],  baz: 'zwie' } },]
      end

      subject { ArrayFieldExample.as_csv(search_results) }

      it { is_expected.to eq(body_of('array_field.csv')) }
    end

    context 'with field containing nested document' do
      before do
        class NestedExample
          include SeparatedValuesable
          self.separated_values_config = [:foo, { bar: [:do, :re] }]
        end
      end

      after { Object.send(:remove_const, :NestedExample) }

      let(:search_results) do
        [{ _source: { foo: 'One',
                      bar: { do: 'a', re: 'b', mi: 'c' },
                      baz: 'eins', }, },
         { _source: { foo: 'Two',
                      bar: { do: 'U', re: 'V', mi: 'W' },
                      baz: 'zwie', }, },]
      end

      subject { NestedExample.as_csv(search_results) }

      it { is_expected.to eq(body_of('nested.csv')) }
    end

    context 'with field containing array of nested documents' do
      before do
        class ArrayOfNestedExample
          include SeparatedValuesable
          self.separated_values_config = [:foo, { bar: [:do, :re] }]
        end
      end

      after { Object.send(:remove_const, :ArrayOfNestedExample) }

      let(:search_results) do
        [{ _source: { foo: 'One',
                      bar: [{ do: 'a', re: 'b', mi: 'c' }, { do: 'd', re: 'e', mi: 'f' }],
                      baz: 'eins', }, },
         { _source: { foo: 'Two',
                      bar: [{ do: 'U', re: 'V', mi: 'W' }, { do: 'X', re: 'Y', mi: 'Z' }],
                      baz: 'zwie', }, },
         { _source: { foo: 'Three',
                      bar: [],
                      baz: 'drei', }, },]
      end

      subject { ArrayOfNestedExample.as_csv(search_results) }

      it { is_expected.to eq(body_of('array_of_nested.csv')) }
    end

    context 'with everything that can be thrown at it' do
      before do
        class BonanzaExample
          include SeparatedValuesable
          self.separated_values_config = [
            :name,
            :alt_names,
            { source: [:fullname] },
            { addresses: [:address, :city, :country] },
            { foo: [:bar] },
          ]
        end
      end

      after { Object.send(:remove_const, :BonanzaExample) }

      let(:search_results) do
        [{ _source: { name:      'Joe Bloggs',
                      alt_names: ['Joseph Bloggs', 'Joe Bloggs; Junior', 'Joe Bloggs, Junior'],
                      source:    { code: 'ABC', fullname: 'Always Best Choice, Ltd.' },
                      addresses: [{ address: '1:2:3 High St.',
                                    city:    'Springfield',
                                    state:   'Dorne',
                                    country: 'NZ', },
                                  { address: '22 Low Rd',
                                    city:    'Semi;colon, Ville',
                                    state:   'Dorne',
                                    country: 'AU', },
                                  { address: '',
                                    city:    '',
                                    state:   '',
                                    country: 'GB', },], }, },]
      end

      subject { BonanzaExample.as_csv(search_results) }

      it { is_expected.to eq(body_of('bonanza.csv')) }
    end
  end

  describe '#as_tsv' do
    context 'with no nested documents' do
      before do
        class NoNestedTabsExample
          include SeparatedValuesable
          self.separated_values_config = [:foo, :bar]
        end
      end

      after { Object.send(:remove_const, :NoNestedTabsExample) }

      let(:search_results) do
        [{ _source: { foo: 'One', bar: 'Satu', baz: 'eins' } },
         { _source: { foo: 'Two', bar: 'Dua',  baz: 'zwie' } },]
      end

      subject { NoNestedTabsExample.as_tsv(search_results) }

      it { is_expected.to eq(body_of('no_nested_tabs.csv')) }
    end
  end

  def body_of(filename)
    open("#{File.dirname(__FILE__)}/separated_valuesable/#{filename}").read
  end
end
