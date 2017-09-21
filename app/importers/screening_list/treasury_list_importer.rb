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
      source = Nokogiri::XML(loaded_resource)
      @source_list_url = @resource =~ URI.regexp ? @resource : nil
      @source_list_url = UrlMapper.get_bitly_url(@source_list_url, model_class) if @source_list_url
      @source_information_url = UrlMapper.get_bitly_url(self.class.source_information_url, model_class) if self.class.source_information_url

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
      doc[:source_list_url] = @source_list_url
      doc[:source_information_url] = @source_information_url
      doc[:name] = extract_name(node)
      doc[:type] = doc[:sdn_type] || doc[:nsp_type]
      doc.delete(:sdn_type)
      doc.delete(:nsp_type)

      doc.merge!(extract_simple_nested_fields(node))
      doc.merge!(extract_complex_nested_fields(node))

      make_names(doc)

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
      address = make_addr(hash, address_line_keys)
      hash[:address] = address.present? ? address : nil

      hash[:country] &&= lookup_country(hash[:country].squish)

      full_address_keys  = %i(address1 address2 address3 city country postal_code state)
      full_address = make_addr(hash, full_address_keys)
      hash[:full_address] = full_address.present? ? full_address : nil

      hash.except(*address_line_keys)
    end

    def make_addr(hash, keys)
      keys.map do |field|
        hash[field].present? ? hash[field] : nil
      end.compact.join(', ',).squish
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
