module TariffRate
  class Query < ::Query
    attr_reader :sources

    def initialize(options = {})
      super
      @q = options[:q] if options[:q].present?
      @sources = options[:sources].present? ? options[:sources].upcase.split(',') : []
      @sort = '_score,source_id'
      @final_year = options[:final_year] if options[:final_year].present?
      @partner_start_year = options[:partner_start_year] if options[:partner_start_year].present?
      @reporter_start_year = options[:reporter_start_year] if options[:reporter_start_year].present?
    end

    private

    def generate_query(json)
      multi_fields = %i(subheading_description tariff_rate_quota_note rule_text tariff_line)
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
            generate_date_range(json, 'final_year', @final_year) if @final_year
            generate_date_range(json, 'partner_start_year', @partner_start_year) if @partner_start_year
            generate_date_range(json, 'reporter_start_year', @reporter_start_year) if @reporter_start_year
          end
        end
      end if @sources.any? || @final_year || @partner_start_year || @reporter_start_year
    end
  end
end
