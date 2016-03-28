require 'open-uri'

module TradeLead
  class StateData
    include Importable
    include VersionableResource

    ENDPOINT = 'http://bids.state.gov/geoserver/opengeo/ows?service=WFS&version=1.0.0&request=GetFeature&srsName=EPSG:4326&typeName=opengeo%3ADATATABLE&outputformat=json&FILTER=%3CFilter%3E%0A%3CPropertyIsEqualTo%3E%0A%09%09%09%3CPropertyName%3ECleared%3C%2FPropertyName%3E%0A%09%09%09%3CLiteral%3E1%3C%2FLiteral%3E%0A%09%09%3C%2FPropertyIsEqualTo%3E%0A%3C%2FFilter%3E'
    CONTAINS_MAPPER_LOOKUPS = true

    COLUMN_HASH = {
      Project_Title:              :title,
      Source:                     :lead_source,
      Project_Number:             :project_number,
      Project_Announced:          :publish_date,
      Tender_Date:                :end_date,
      Country:                    :country,
      Status:                     :status,
      Sector:                     :industry,
      Specific_Location:          :specific_location,
      Project_Size:               :project_size,
      Implementing_Entity:        :procurement_organization,
      Project_Funding_Source:     :funding_source,
      Borrowing_Entity:           :borrowing_entity,
      Project_Description:        :description,
      Keyword:                    :tags,
      Link_To_Project:            :url,
      Project_POCs:               :contact,
      Post_Comments:              :comments,
      Submitting_Officer:         :submitting_officer,
      Submitting_Officer_Contact: :submitting_officer_contact,
    }

    def import
      doc = JSON.parse(open(@resource).read, symbolize_names: true)

      entries = []
      doc[:features].each do |article_hash|
        next if article_hash[:properties][:Status].casecmp('fulfilled').zero?
        entries << process_entry_info(article_hash)
      end

      TradeLead::State.index(entries)
    end

    private

    def process_entry_info(entry_hash)
      entry = remap_keys(COLUMN_HASH, entry_hash[:properties])

      entry[:id] = entry_hash[:id]
      entry[:country] = lookup_country(entry[:country].squish)
      entry.merge! add_geo_fields([entry[:country]])
      entry[:source] = TradeLead::State.source[:code]
      entry[:ita_industries] = entry[:industry] ? [normalize_industry(entry[:industry])].compact.flatten.uniq : []

      entry = process_additional_fields(entry)

      entry
    end

    def process_additional_fields(entry)
      %i(publish_date end_date).each do |field|
        begin
          entry[field] &&= Date.parse(entry[field]).iso8601
        rescue
          nil
        end
      end

      %i(comments description title tags contact).each do |field|
        entry[field].squish! if entry[field]
      end
      entry[:url] = UrlMapper.get_bitly_url(entry[:url], model_class) if entry[:url].present?
      entry
    end
  end
end
