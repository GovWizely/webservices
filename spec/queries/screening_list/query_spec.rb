require 'spec_helper'

describe ScreeningList::Query do
  let(:fixtures_dir) { "#{File.dirname(__FILE__)}/query" }

  describe '#new' do
    it_behaves_like 'a paginated query'

    context 'when options include countries' do
      let(:query) { described_class.new(countries: 'us,ca') }

      describe '#countries' do
        subject { query.countries }
        it { is_expected.to eq(%w(US CA)) }
      end
    end
  end

  describe '#generate_search_body' do

    context 'when options include name and fuzziness' do
      let(:query) { described_class.new(name: 'mohamed', fuzziness: '0') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_name_and_fuzziness.json").read }
      it 'generates search body with name and fuzziness' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include only q' do
      let(:query) { described_class.new(q: 'fish') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_multi_match.json").read }

      it 'generates search body with q query' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when the search q is "Müller" with invalid utf-8 byte' do
      it 'replaces all the invalid bytes' do
        expect { described_class.new(q: "Müller\255".force_encoding('UTF-8')) }.not_to raise_error
        expect(described_class.new(q: "Müller\255".force_encoding('UTF-8')).generate_search_body).to include("\"Müller\"")
      end
    end

    context 'when options include only type' do
      let(:query) { described_class.new(type: 'Entity') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_type_filter.json").read }

      it 'generates search body with type filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include only sources' do
      let(:query) { described_class.new(sources: 'SDN') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_sources_filter.json").read }

      it 'generates search body with type filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include only address' do
      let(:query) { described_class.new(address: 'Avenida Bady Bassitt') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_address.json").read }

      it 'generates search body with type filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include address and fuzziness' do
      let(:query) { described_class.new(address: 'Avenida Bady Bassitt', fuzziness: 2) }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_address_and_fuzziness.json").read }

      it 'generates search body with type filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include only countries' do
      let(:query) { described_class.new(countries: 'us,ca') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_countries_filter.json").read }

      it 'generates search body with countries filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include all possible fields' do
      let(:query) do
        described_class.new(countries: 'us,ca',
                            q:         'fish',
                            sources:   'SDN',
                            type:      'Entity')
      end
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_all.json").read }

      it 'generates search body with countries filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include end_date' do
      let(:query) { described_class.new(end_date: '2015-08-27 TO 2015-08-28') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_end_date.json").read }

      it 'generates search body with countries filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include start_date' do
      let(:query) { described_class.new(start_date: '2015-08-27 TO 2015-08-28') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_start_date.json").read }

      it 'generates search body with countries filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include expiration_date' do
      let(:query) { described_class.new(expiration_date: '2015-08-27 TO 2015-08-28') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_expiration_date.json").read }

      it 'generates search body with countries filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

    context 'when options include issue_date' do
      let(:query) { described_class.new(issue_date: '2015-08-27 TO 2015-08-28') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_issue_date.json").read }

      it 'generates search body with countries filter' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end
    end

  end
end
