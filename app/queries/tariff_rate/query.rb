module TariffRate
  class Query < ::Query
    attr_reader :countries, :sources

    def initialize(options = {})
      super
      @q = options[:q] if options[:q].present?
      @countries = options[:countries].upcase.split(',') if options[:countries].present?
      @sources = options[:sources].present? ? options[:sources].upcase.split(',') : []
      @sort = '_score,source_id'
    end

    private

    def generate_query(json)
      multi_fields = %i(description tariff_rate_quota_note rule_text tariff_line)
      json.query do
        json.bool do
          json.must do
            json.child! { generate_multi_match(json, multi_fields, @q) } if @q
          end
        end
      end if @q
    end

    def generate_filter(json)
      json.filter do
        json.bool do
          json.must do
            json.child! { json.terms { json.source @sources } } if @sources.any?
            json.child! { json.terms { json.countries @countries } } if @countries
          end
        end
      end if @countries || @sources.any?
    end
  end
end
