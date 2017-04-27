require 'spec_helper'
describe DataSources::Transformer do
  let(:metadata) { { source: 'Currency', description: 'blah', indexed: true, plural: false, type: 'enum' } }

  context 'no transformations present' do
    let(:transformer) { DataSources::Transformer.new(metadata) }

    it 'returns the input value' do
      expect(transformer.transform('foo')).to eq('foo')
    end
  end

  context 'upcasing' do
    let(:transformer) { DataSources::Transformer.new(metadata.merge(transformations: %w(upcase))) }

    it 'returns the value upcased' do
      expect(transformer.transform('foo')).to eq('FOO')
    end
  end

  context 'squishing' do
    let(:transformer) { DataSources::Transformer.new(metadata.merge(transformations: %w(squish))) }

    it 'returns the value squished' do
      expect(transformer.transform(' foo  bar ')).to eq('foo bar')
    end
  end

  context 'downcasing and titleizing' do
    let(:transformer) { DataSources::Transformer.new(metadata.merge(transformations: %w(downcase titleize))) }

    it 'returns the value downcased' do
      expect(transformer.transform('uNITED kingdom')).to eq('United Kingdom')
    end
  end

  context 'extracting successive substrings' do
    let(:transformer) do
      transformation_array = [{ from: 1 }, { first: 11 }, { last: 2 }]
      DataSources::Transformer.new(metadata.merge(transformations: transformation_array))
    end

    it 'returns the appropriate substring' do
      expect(transformer.transform('0123456789abcdefg')).to eq('ab')
    end
  end

  context 'splitting into array' do
    let(:transformer) do
      transformation_array = [{ split: ', ' }]
      DataSources::Transformer.new(metadata.merge(transformations: transformation_array))
    end

    it 'returns the appropriate array' do
      expect(transformer.transform('val1 with commas, another')).to eq(['val1 with commas', 'another'])
    end
  end

  context 'operating on array' do
    let(:transformer) do
      transformation_array = [{ split: ',' }, { first: 2 }]
      DataSources::Transformer.new(metadata.merge(transformations: transformation_array))
    end

    it 'returns the appropriately modified array' do
      expect(transformer.transform('efgh,abcd')).to eq(%w(ab ef))
    end
  end

  context 'replacing text' do
    let(:transformer) do
      transformation_array = [{ gsub: ['*', ''] }, { sub: %w(siam thailand) }]
      DataSources::Transformer.new(metadata.merge(transformations: transformation_array))
    end

    it 'returns the appropriate new string' do
      expect(transformer.transform('**siam used to be called siam***')).to eq('thailand used to be called siam')
    end
  end

  context 'sanitizing text' do
    let(:transformer) { DataSources::Transformer.new(metadata.merge(transformations: [{ sanitize: 'xhtml1' }])) }

    it 'returns the appropriate new string' do
      expect(transformer.transform('<b>bold</b> &amp;     face ')).to eq('bold & face')
    end
  end

  context 'reformatting non-standard date strings' do
    let(:transformer) { DataSources::Transformer.new(metadata.merge(transformations: [{ reformat_date: '%m/%d/%Y' }])) }

    it 'returns the value in the new format' do
      expect(transformer.transform('6/7/2015')).to eq('2015-06-07')
    end
  end

  context 'default values' do
    let(:transformer) { DataSources::Transformer.new(metadata.merge(default: 'USD')) }

    it 'returns the default value' do
      expect(transformer.transform('')).to eq('USD')
      expect(transformer.transform('EUR')).to eq('EUR')
      expect(transformer.transform(nil)).to eq('USD')
    end
  end

  context 'mapping from external API' do
    context 'single value mapping' do
      let(:transformer) do
        transformation_array = [{ external_mapping: { urls: [
          { url: 'https://restcountries.eu/rest/v1/name/ORIGINAL_VALUE', result_path: '$[0].alpha2Code' },
          { url: 'http://im.govwizely.com/api/terms.json?mapped_term=Missing%20Country:%20ORIGINAL_VALUE&source=TradeEvent::Ustda', result_path: '$[0].name' },
        ], }, },]
        DataSources::Transformer.new(metadata.merge(transformations: transformation_array))
      end

      context 'mapping exists in first URL' do
        it 'returns the appropriate value' do
          VCR.use_cassette('importers/data_sources/external_mapping_transformation/ivory_coast.yml') do
            expect(transformer.transform('ivory coast')).to eq('CI')
          end
        end
      end

      context 'mapping exists in backfill URL' do
        it 'returns the appropriate value' do
          VCR.use_cassette('importers/data_sources/external_mapping_transformation/seattle.yml') do
            expect(transformer.transform('Seattle, WA')).to eq('United States')
          end
        end
      end

      context 'mapping does not exist' do
        it 'returns nil' do
          VCR.use_cassette('importers/data_sources/external_mapping_transformation/nope.yml') do
            expect(transformer.transform('nope')).to be_nil
          end
        end
      end

      context 'something goes terribly wrong' do
        it 'returns nil' do
          expect(transformer.transform('no cassette so an exception is thrown')).to be_nil
        end
      end
    end

    context 'multi-value mapping' do
      let(:transformer) do
        transformation_array = [{ external_mapping: { urls: [
          { url:         'http://im.govwizely.com/api/terms.json?mapped_term=ORIGINAL_VALUE&source=TradeLead::State',
            result_path: '$..name',
            multi_value: true, },
        ], }, },]
        DataSources::Transformer.new(metadata.merge(transformations: transformation_array))
      end

      it 'returns the appropriate array' do
        VCR.use_cassette('importers/data_sources/external_mapping_transformation/construction.yml') do
          expect(transformer.transform('construction')).to eq(['Design and Construction', 'Construction Services'])
        end
      end
    end
  end

  context 'adding ITA taxonomy countries and world regions' do
    context 'source field is a country and country is needed' do 

    end

    context 'source field is a country and world_region is needed' do

    end

    context 'source field is a region and country is needed' do 

    end

    context 'source field is a region and world_region is needed' do

    end

    context 'the mapping for the source field is not found' do

    end
  end

  context 'an unsupported transformation is specified' do
    let(:transformer) { DataSources::Transformer.new(metadata.merge(transformations: %w(nope))) }

    it 'raises an ArgumentError' do
      expect { transformer.transform('uh oh') }.to raise_error(ArgumentError)
    end
  end
end
