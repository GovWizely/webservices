require 'open-uri'

module TradeLead
  module FbopenImporter
    class FullData
      include Importable
      attr_accessor :naics_mapper

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
        self.naics_mapper = NaicsMapper.new
      end

      def import
        batched_import { |batch| TradeLead::Fbopen.index(batch) }
      end

      def model_class
        TradeLead::Fbopen
      end

      private

      def batched_import(&block)
        bp = BatchProcessor.new(&block)
        open(@resource) do |file|
          Nokogiri::XML::Reader.from_io(file).each do |node|
            if should_import?(node)
              e = process_xml_entry extract_entry(node)
              bp.batched_process(e)
            end
          end
          bp.process!
        end
      end

      def should_import?(node)
        %w(PRESOL COMBINE MOD).include?(node.name) && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
      end

      def extract_entry(node)
        entry = extract_fields(Nokogiri::XML(node.outer_xml), XPATHS)
        entry[:notice_type] = node.name
        entry
      end

      def process_xml_entry(entry)
        entry.symbolize_keys!
        return nil if !(entry[:specific_location].try(:upcase) =~ /\A[A-Z]{2}\z/) || entry[:specific_location] == 'US'

        entry = process_xml_dates(entry)
        return nil unless entry[:end_date].nil? || entry[:end_date] >= Date.today

        entry = process_additional_fields(entry)
        entry[:url] = UrlMapper.get_bitly_url(entry[:url], model_class) if entry[:url].present?
        entry
      end

      def process_additional_fields(entry)
        entry[:description] &&= Nokogiri::HTML.fragment(entry[:description]).inner_text.squish
        entry[:contact] &&= Nokogiri::HTML.fragment(entry[:contact]).inner_text.squish
        entry[:source] = TradeLead::Fbopen.source[:code]
        entry[:id]      = entry[:contract_number]
        entry = process_industries(entry)
        entry
      end

      def process_xml_dates(entry)
        entry[:publish_date] = date_from_string(entry[:publish_date])
        entry[:resp_date]    = date_from_string(entry[:resp_date])
        entry[:arch_date]    = date_from_string(entry[:arch_date])

        entry[:end_date] = extract_end_date(entry)
        entry.delete(:resp_date)
        entry.delete(:arch_date)

        entry
      end

      # Parse string and return Date object or nil if date is invalid
      def date_from_string(date)
        Date.strptime(date, '%m%d%Y') if date =~ /[0-9]{8}/
      end

      def extract_end_date(entry)
        [entry[:arch_date], entry[:resp_date]].reject(&:nil?).max
      end
    end
  end
end
