require 'open-uri'
require 'uri'

module ScreeningList
  module TreasuryListImporter
    def self.included(base)
      base.class_eval do
        class << self
          attr_accessor :default_endpoint, :source_information_url, :program_id
        end
      end
    end

    def initialize(resource = nil)
      @resource = resource || self.class.default_endpoint
      @program_id = self.class.program_id
    end

    def import
      source = Nokogiri::XML(open(@resource))

      docs = source.xpath(document_node_xpath).map do |node|
        process_node(node) if should_process?(node)
      end.compact

      model_class.index docs
    end

    private

    def should_process?(node)
      @program_id == 'SDN' || node.xpath('.//xmlns:program').map(&:text).compact.any? { |p| p.include?(@program_id) }
    end

    def document_node_xpath
      '//xmlns:sdnEntry'
    end

    SINGLE_VALUED_XPATHS = {
      entity_number:            './xmlns:uid',
      sdn_type:                 './xmlns:sdnType',
      nsp_type:                 './xmlns:nspType',
      title:                    './xmlns:title',
      call_sign:                './/xmlns:callSign',
      vessel_type:              './/xmlns:vesselType',
      gross_tonnage:            './/xmlns:tonnage',
      gross_registered_tonnage: './/xmlns:grossRegisteredTonnage',
      vessel_flag:              './/xmlns:vesselFlag',
      vessel_owner:             './/xmlns:vesselOwner',
      remarks:                  './xmlns:remarks',
    }.freeze

    def process_node(node)
      doc = extract_fields(node, SINGLE_VALUED_XPATHS)

      doc[:id] = doc[:entity_number]
      doc[:source] = model_class.source
      doc[:source_list_url] = @resource =~ URI.regexp ? @resource : nil
      doc[:source_information_url] = self.class.source_information_url
      doc[:name] = extract_name(node)
      doc[:type] = doc[:sdn_type] || doc[:nsp_type]
      doc.delete(:sdn_type)
      doc.delete(:nsp_type)

      doc.merge!(extract_simple_nested_fields(node))
      doc.merge!(extract_complex_nested_fields(node))

      stopwords   = %w(and the los)
      common_words = %w(co company corp corporation inc incorporated limited ltd mr mrs ms organization sa sas llc)

      ##
      # index 2 forms of each name for both "name" and "alt_names",
      # one with punctuation and "stopwords" removed and
      # one the above plus "common" words removed.
      #
      # then store additional modified versions of the two in the following ways:
      #
      #     1) reversed
      #     2) with white space removed
      #     3) reversed with white space removed
      #

      doc[:name_idx]      = doc[:name].gsub(/[[:punct:]]/, ' ').squeeze(' ')
      doc[:name_idx]      = doc[:name_idx].split.delete_if { |name| stopwords.include?(name.downcase) }.join(' ')
      doc[:rev_name]      = doc[:name_idx].split.reverse.join(' ')
      doc[:trim_name]     = doc[:name_idx].gsub(/\s+/, '')
      doc[:trim_rev_name] = doc[:rev_name].gsub(/\s+/, '')

      if !(doc[:name_idx].downcase.split & common_words).empty?
        doc[:name_no_common]          = doc[:name_idx].split.delete_if { |name| common_words.include?(name.downcase) }.join(' ')
        doc[:rev_name_no_common]      = doc[:name_no_common].split.reverse.join(' ')
        doc[:trim_name_no_common]     = doc[:name_no_common].gsub(/\s+/, '')
        doc[:trim_rev_name_no_common] = doc[:rev_name_no_common].gsub(/\s+/, '')
      end

      if doc[:alt_names].present?
        doc[:alt_names_idx]          = doc[:alt_names].map { |name| name.gsub(/[[:punct:]]/, '').squeeze(' ') }
        doc[:alt_names_idx]          = doc[:alt_names_idx].map { |name| name.split.delete_if { |word| stopwords.include?(word.downcase) }.join(' ') }
        doc[:rev_alt_names]          = doc[:alt_names_idx].map { |name| name.split.reverse.join(' ') }
        doc[:trim_alt_names]         = doc[:alt_names_idx].map { |name| name.gsub(/\s+/, '') }
        doc[:trim_rev_alt_names]     = doc[:rev_alt_names].map { |name| name.gsub(/\s+/, '') }

        if !(doc[:alt_names_idx].map!(&:downcase).join(' ').split & common_words).empty?
          doc[:alt_names_no_common]    = doc[:alt_names_idx].map { |name| name.split.delete_if { |word| common_words.include?(word.downcase) }.join(' ') }
          doc[:rev_alt_no_common]      = doc[:alt_names_no_common].map { |name| name.split.reverse.join(' ') }
          doc[:trim_alt_no_common]     = doc[:alt_names_no_common].map { |name| name.gsub(/\s+/, '') }
          doc[:trim_rev_alt_no_common] = doc[:rev_alt_no_common].map { |name| name.gsub(/\s+/, '') }
        end
      end

      doc
    end

    NAME_XPATHS = {
      lastName:  './xmlns:lastName',
      firstName: './xmlns:firstName',
    }.freeze

    def extract_name(node)
      hash = extract_fields(node, NAME_XPATHS)
      name = %i(lastName firstName).map { |f| hash[f] }.compact.join(', ').squish
      name.present? ? name : nil
    end

    def extract_simple_nested_fields(node)
      fields = {}
      fields[:alt_names] = node.xpath('.//xmlns:aka')
                           .map { |n| extract_name(n) }.compact
      fields[:programs] = node.xpath('.//xmlns:program')
                          .map(&:text).compact
      fields[:nationalities] = node.xpath('.//xmlns:nationality')
                               .map { |n| extract_nationality(n) }.compact
      fields[:citizenships] = node.xpath('.//xmlns:citizenship')
                              .map { |n| extract_citizenship(n) }.compact
      fields[:dates_of_birth] = node.xpath('.//xmlns:dateOfBirthItem')
                                .map { |n| extract_dob(n) }.compact
      fields[:places_of_birth] = node.xpath('.//xmlns:placeOfBirthItem')
                                 .map { |n| extract_pob(n) }.compact
      fields
    end

    ADDRESS_XPATHS = {
      address1:    './xmlns:address1',
      address2:    './xmlns:address2',
      address3:    './xmlns:address3',
      city:        './xmlns:city',
      country:     './xmlns:country',
      postal_code: './xmlns:postalCode',
      state:       './xmlns:stateOrProvince',
    }.freeze

    def extract_address(node)
      hash = extract_fields(node, ADDRESS_XPATHS)
      address_line_keys = %i(address1 address2 address3)

      address = address_line_keys.map do |field|
        hash[field].present? ? hash[field] : nil
      end.compact.join(', ').squish
      hash[:address] = address.present? ? address : nil

      hash[:country] &&= lookup_country(hash[:country].squish)

      hash.except(*address_line_keys)
    end

    ID_XPATHS = {
      country:         './xmlns:idCountry',
      expiration_date: './xmlns:expirationDate',
      issue_date:      './xmlns:issueDate',
      number:          './xmlns:idNumber',
      type:            './xmlns:idType',
    }.freeze

    def extract_id(node)
      id = extract_fields(node, ID_XPATHS)
      id[:country] &&= lookup_country(id[:country])
      id[:issue_date] &&= parse_date(id[:issue_date])
      id[:expiration_date] &&= parse_date(id[:expiration_date])
      id
    end

    def extract_nationality(node)
      lookup_country(node.xpath('./xmlns:country').text)
    end

    def extract_citizenship(node)
      lookup_country(node.xpath('./xmlns:country').text)
    end

    def extract_dob(node)
      text = node.xpath('./xmlns:dateOfBirth').text
      parse_date(text) || text
    end

    def extract_pob(node)
      node.xpath('./xmlns:placeOfBirth').text
    end

    def extract_complex_nested_fields(node)
      fields = {}
      fields[:addresses] =
        node.xpath('.//xmlns:address').map { |n| extract_address(n) }
      fields[:ids] =
        node.xpath('.//xmlns:id').map { |n| extract_id(n) }
      fields
    end
  end
end
