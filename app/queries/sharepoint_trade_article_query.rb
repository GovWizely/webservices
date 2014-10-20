class SharepointTradeArticleQuery < Query
  SEARCH_TERMS = [
    :title, :short_title, :summary, :creation_date_start, :creation_date_end,
    :release_date_start, :release_date_end, :expiration_date_start, :expiration_date_end,
    :content, :keyword, :export_phases, :industries, :trade_regions, :trade_programs,
    :trade_initiatives, :countries, :source_agency, :source_business_units,
    :source_offices, :topic, :sub_topics, :geo_region, :geo_subregions, :q
  ]

  def initialize(options)
    super(options)
    SEARCH_TERMS.each do |term|
      instance_variable_set("@#{term}", options[term].downcase) if options[term].present?
    end
    @countries = @countries.split(',') if @countries
  end

  def generate_query(json)
    # multi_fields = %i(question answer industry)
    json.query do
      json.bool do
        json.must do |must_json|
          generate_top_level_queries(must_json)
          generate_nested_queries(must_json, 'source_agencies', %w(source_agency source_business_units source_offices)) if has_source_agency_options?
          generate_nested_queries(must_json, 'topics', %w(topic sub_topics)) if has_topic_options?
          generate_nested_queries(must_json, 'geo_regions', %w(geo_region geo_subregions)) if has_geo_region_options?
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

  def generate_nested_queries(json, path, terms)
    json.child! do
      json.nested do
        json.path path
        json.query do
          json.bool do
            json.must do |must_json|
              terms.each do |term|
                must_json.child! { must_json.match { must_json.set! path + '.' + term,  instance_variable_get("@#{term}") } } if instance_variable_get("@#{term}")
              end
            end
          end
        end
      end
    end
  end

  def generate_top_level_queries(json)
    multi_fields = %i(title content)
    json.child! { generate_multi_match(json, multi_fields, @q) } if @q
    terms = %w(title short_title summary content keyword export_phases industries trade_regions trade_programs trade_initiatives)
    terms.each do |term|
      json.child! { json.match { json.set! term, instance_variable_get("@#{term}") } } if instance_variable_get("@#{term}")
    end
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
    @title || @short_title || @summary || @content || @keyword || @export_phases || @industries \
    || @trade_regions || @trade_programs || @trade_initiatives || has_source_agency_options? \
    || has_topic_options? || has_geo_region_options? || @q
  end

  def has_source_agency_options?
    @source_agency || @source_business_units || @source_offices
  end

  def has_topic_options?
    @topic || @sub_topics
  end

  def has_geo_region_options?
    @geo_region || @geo_subregions
  end

  def has_filter_options?
    @creation_date_start || @creation_date_end || @release_date_start || @release_date_end \
    || @expiration_date_start || @expiration_date_end || @countries
  end
end
