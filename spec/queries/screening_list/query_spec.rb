require 'spec_helper'

shared_examples 'a ScreeningList query' do
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
    context 'when options include name' do
      let(:query) { described_class.new(name: 'mohamed') }
      let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_name.json").read }
      it 'generates search body with name' do
        expect(JSON.parse(query.generate_search_body)).to eq(search_body)
      end

      context 'and fuzzy_name is true' do
        let(:query) { described_class.new(name: 'mohamed', fuzzy_name: 'true') }
        let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_name_and_fuzzy.json").read }
        it 'generates search body with name' do
          expect(JSON.parse(query.generate_search_body)).to eq(search_body)
        end

        context 'and name in "common words"' do
          let(:query) { described_class.new(name: 'company', fuzzy_name: 'true') }
          let(:search_body) { JSON.parse open("#{fixtures_dir}/search_body_with_name_and_fuzzy_and_common_word.json").read }
          it 'generates search body with name' do
            expect(JSON.parse(query.generate_search_body)).to eq(search_body)
          end
        end
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
                            type:      'Entity',)
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

%w(Dpl Dtc El Fse Isn Plc Sdn Ssi Uvl).each do |i|
  describe "ScreeningList::#{i}Query".constantize do
    it_behaves_like 'a ScreeningList query'
  end
end
