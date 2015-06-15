require 'spec_helper'

describe EccnData do
  before { Eccn.recreate_index }
  let(:fixtures_file) { "#{Rails.root}/spec/fixtures/eccns/eccns.csv" }
  let(:importer) { described_class.new(fixtures_file) }
  let(:expected) { YAML.load_file("#{File.dirname(__FILE__)}/eccn/results.yaml") }

  it_behaves_like 'an importer which can purge old documents'

  describe '#import' do
    it 'loads Eccns from specified resource' do
      expect(Eccn).to receive(:index) do |results|
        expect(results).to eq(expected)
      end
      importer.import
    end

    it 'fails on unrecognized headers' do
      bad_importer = described_class.new("#{Rails.root}/spec/fixtures/eccns/eccns_bad.csv")
      expect { bad_importer.import }.to raise_error
    end
  end

  describe '#process_row' do
    it 'handles a row with a single ECCN' do
      r = importer.send(:process_row,
                        ['Cryptographic enabling software', '5D002d', nil, nil, nil, nil])
      expect(r).to eq(
        description: 'Cryptographic enabling software',
        eccn0:       '5D002d',
        eccn1:       nil,
        eccn2:       nil,
        eccn3:       nil,
        eccn4:       nil,
        url0:        'http://www.bis.doc.gov/index.php/forms-documents/doc_download/951-ccl5-pt2',
        url1:        nil,
        url2:        nil)
    end

    it 'handles a row with four ECCNs' do
      r = importer.send(:process_row,
                        ['Detection and protection equipment and components', '1A004', '1A995', '2B351', '2B352', nil])
      expect(r).to eq(
        description: 'Detection and protection equipment and components',
        eccn0:       '1A004',
        eccn1:       '1A995',
        eccn2:       '2B351',
        eccn3:       '2B352',
        eccn4:       nil,
        url0:        'http://www.bis.doc.gov/index.php/forms-documents/doc_download/989-ccl1',
        url1:        'http://www.bis.doc.gov/index.php/forms-documents/doc_download/734-ccl2',
        url2:        nil)
    end
  end

  describe '#eccn_to_url' do
    it 'handles "category X" case' do
      r = importer.send(:eccn_to_url, 'Category 0')
      expect(r).to eq('http://www.bis.doc.gov/index.php/forms-documents/doc_download/988-ccl0')
    end

    it 'handles "category X, part  Y" case' do
      r = importer.send(:eccn_to_url, 'Category 5, Part  2 Note 3 (b)')
      expect(r).to eq('http://www.bis.doc.gov/index.php/forms-documents/doc_download/950-ccl5-pt1')
    end

    it 'ignores other notes' do
      r = importer.send(:eccn_to_url, 'see product group D for controls in each category')
      expect(r).to eq(nil)
    end

    it 'converts every leading-digit category correctly' do
      examples = { '0A981'    => 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/988-ccl0',
                   '1C351d2'  => 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/989-ccl1',
                   '2A001c'   => 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/734-ccl2',
                   '3B001f1'  => 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/990-ccl3',
                   '4A003e'   => 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/1055-ccl4',
                   '5A002d'   => 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/951-ccl5-pt2',
                   '5D001d'   => 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/950-ccl5-pt1',
                   '6A008e'   => 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/952-ccl6',
                   '7A002'    => 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/1089-ccl7',
                   '8A002o3a' => 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/863-category-8-marine',
                   '9A610y3'  => 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/991-ccl9' }
      examples.each do |code, url|
        expect(importer.send(:eccn_to_url, code)).to eq(url)
      end
    end
  end
end
