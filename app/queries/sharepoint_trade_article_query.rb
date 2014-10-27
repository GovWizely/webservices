class SharepointTradeArticleQuery < Query
  SEARCH_TERMS = [
    :creation_date_start, :creation_date_end,
    :release_date_start, :release_date_end, :expiration_date_start, :expiration_date_end,
    :export_phases, :industries, :trade_regions, :trade_programs,
    :trade_initiatives, :countries, :source_agencies, :source_business_units,
    :source_offices, :topics, :sub_topics, :geo_regions, :geo_subregions, :q
  ]

  def initialize(options)
    super
    SEARCH_TERMS.each do |term|
      instance_variable_set("@#{term}", options[term].downcase) if options[term].present?
    end
    @countries = @countries.split(',') if @countries
  end

  def generate_query(json)
    terms = %w(export_phases industries trade_regions trade_programs trade_initiatives 
            source_agencies source_business_units source_offices geo_regions geo_subregions topics sub_topics)
    q_terms = %w(title short_title summary content keyword)
    json.query do
      json.bool do
        json.must do |_must_json|
          json.child! { generate_multi_match(json, q_terms+terms, @q) } if @q
          terms.each do |term|
            json.child! { json.match { json.set! term, instance_variable_get("@#{term}") } } if instance_variable_get("@#{term}")
          end
        end
      end
    end if has_query_options?
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          generate_date_range(json, 'creation_date')
          generate_date_range(json, 'release_date')
          generate_date_range(json, 'expiration_date')
          json.child! { json.terms { json.countries @countries } } if @countries
        end
      end
    end if has_filter_options?
  end

  def generate_date_range(json, date_str)
    date_start = instance_variable_get("@#{date_str}_start")
    date_end = instance_variable_get("@#{date_str}_end")
    if date_start || date_end
      json.child! do
        json.range do
          json.set! date_str.to_sym do
            json.from date_start if date_start
            json.to date_end if date_end
          end
        end
      end
    end
  end

  def has_query_options?
    @export_phases || @industries || @trade_regions || @trade_programs || @trade_initiatives ||
    @source_agencies || @source_business_units || @source_offices || @topics || @sub_topics ||
    @geo_regions || @geo_subregions || @q
  end

  def has_filter_options?
    @creation_date_start || @creation_date_end || @release_date_start || @release_date_end ||
    @expiration_date_start || @expiration_date_end || @countries
  end
end
