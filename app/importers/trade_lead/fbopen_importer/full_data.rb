require 'open-uri'

module TradeLead
  module FbopenImporter
    class FullData
      include Importer

      XPATHS = {
        publish_date:                     '//DATE',
        procurement_organization:         '//AGENCY',
        procurement_office:               '//OFFICE',
        procurement_organization_address: '//LOCATION',
        classification_code:              '//CLASSCOD',
        industry:                         '//NAICS',
        procurement_office_address:       '//OFFADD',
        title:                            '//SUBJECT',
        contract_number:                  '//SOLNBR',
        resp_date:                        '//RESPDATE',
        arch_date:                        '//ARCHDATE',
        contact:                          '//CONTACT',
        description:                      '//DESC',
        url:                              '//LINK',
        competitive_procurement_strategy: '//SETASIDE',
        specific_location:                '//POPCOUNTRY',
        specific_address:                 '//POPADDRESS',
      }

      DEFAULT_SOURCE = 'ftp://ftp.fbo.gov/datagov/FBOFullXML.xml'

      def initialize(resource = nil, encoding = 'ISO8859-1')
        @resource = resource || DEFAULT_SOURCE
        @encoding = encoding
      end

      def import
        entries = import_full_xml.map { |entry| process_xml_entry(entry) }.compact
        TradeLead::Fbopen.index(entries)
      end

      def model_class
        TradeLead::Fbopen
      end

      private

      def import_full_xml
        entries = []
        open(@resource) do |file|
          Nokogiri::XML::Reader.from_io(file).each do |node|
            if %w(PRESOL COMBINE MOD).include?(node.name) && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
              entry = extract_fields(Nokogiri::XML(node.outer_xml), XPATHS)
              entry[:notice_type] = node.name
              entries << entry
            end
          end
        end
        entries
      end

      def process_xml_entry(entry)
        entry.symbolize_keys!
        return nil if !(entry[:specific_location].try(:upcase) =~ /\A[A-Z]{2}\z/) || entry[:specific_location] == 'US'

        entry = process_xml_dates(entry)
        return nil if entry[:end_date] < Date.today unless entry[:end_date].nil?

        entry[:description] &&= Nokogiri::HTML.fragment(entry[:description]).inner_text.squish
        entry[:contact] &&= Nokogiri::HTML.fragment(entry[:contact]).inner_text.squish
        entry[:source] = TradeLead::Fbopen.source[:code]
        entry[:id]      = entry[:contract_number]
        entry
      end

      def process_xml_dates(entry)
        entry[:publish_date] = valid_date?(entry[:publish_date])
        entry[:resp_date] = valid_date?(entry[:resp_date])
        entry[:arch_date] = valid_date?(entry[:arch_date])

        entry[:end_date] = extract_end_date(entry)
        entry.delete(:resp_date)
        entry.delete(:arch_date)

        entry
      end

      def valid_date?(date)
        if date =~ /[0-9]{8}/
          Date.strptime(date, '%m%d%Y')
        else
          nil
        end
      end

      def extract_end_date(entry)
        if entry[:arch_date].nil? && entry[:resp_date].nil?
          nil
        elsif !entry[:arch_date].nil? && entry[:resp_date].nil?
          entry[:arch_date]
        elsif entry[:arch_date].nil? && !entry[:resp_date].nil?
          entry[:resp_date]
        elsif entry[:resp_date] < entry[:arch_date]
          entry[:arch_date]
        else
          entry[:resp_date]
        end
      end
    end
  end
end
