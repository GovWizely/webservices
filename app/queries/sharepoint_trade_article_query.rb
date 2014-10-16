class SharepointTradeArticleQuery < Query
  def initialize(options)
    super(options)
    @title = options[:title].downcase if options[:title].present?
    @short_title = options[:short_title].downcase if options[:short_title].present?
    @summary = options[:summary].downcase if options[:summary].present?

    @creation_date_start = options[:creation_date_start] if options[:creation_date_start].present?
    @creation_date_end = options[:creation_date_end] if options[:creation_date_end].present?
    @release_date_start = options[:release_date_start] if options[:release_date_start].present?
    @release_date_end = options[:release_date_end] if options[:release_date_end].present?
    @expiration_date_start = options[:expiration_date_start] if options[:expiration_date_start].present?
    @expiration_date_end = options[:expiration_date_end] if options[:expiration_date_end].present?

    @content = options[:content].downcase if options[:content].present?
    @keyword = options[:keyword].downcase if options[:keyword].present?

    @export_phases = options[:export_phases].downcase if options[:export_phases].present?
    @industries = options[:industries].downcase if options[:industries].present?
    @trade_regions = options[:trade_regions].downcase if options[:trade_regions].present?
    @trade_programs = options[:trade_programs].downcase if options[:trade_programs].present?
    @trade_initiatives = options[:trade_initiatives].downcase if options[:trade_initiatives].present?
    @countries = options[:countries].downcase.split(',') if options[:countries].present?

    @source_agency = options[:source_agency].downcase if options[:source_agency].present?
    @source_business_units = options[:source_business_units].downcase if options[:source_business_units].present?
    @source_offices = options[:source_offices].downcase if options[:source_offices].present?

    @topic = options[:topic].downcase if options[:topic].present?
    @sub_topics = options[:sub_topics].downcase if options[:sub_topics].present?
    @geo_region = options[:geo_region].downcase if options[:geo_region].present?
    @geo_subregions = options[:geo_subregions].downcase if options[:geo_subregions].present?
  end

  def generate_query(json)
    # multi_fields = %i(question answer industry)
    json.query do
      json.bool do
        json.must do |must_json|
          must_json.child! { must_json.match { must_json.title @title } } if @title
          must_json.child! { must_json.match { must_json.short_title @short_title } } if @short_title
          must_json.child! { must_json.match { must_json.summary @summary } } if @summary
          must_json.child! { must_json.match { must_json.content @content } } if @content
          must_json.child! { must_json.match { must_json.keyword @keyword } } if @keyword
          must_json.child! { must_json.match { must_json.export_phases @export_phases } } if @export_phases
          must_json.child! { must_json.match { must_json.industries @industries } } if @industries
          must_json.child! { must_json.match { must_json.trade_regions @trade_regions } } if @trade_regions
          must_json.child! { must_json.match { must_json.trade_programs @trade_programs } } if @trade_programs
          must_json.child! { must_json.match { must_json.trade_initiatives @trade_initiatives } } if @trade_initiatives
          must_json.child! { generate_nested_queries(must_json, 'source_agencies', ['source_agency', 'source_business_units', 'source_offices']) } if has_source_agency_options?
          must_json.child! { generate_nested_queries(must_json, 'topics', ['topic', 'sub_topics']) } if has_topic_options?
          must_json.child! { generate_nested_queries(must_json, 'geo_regions', ['geo_region', 'geo_subregions']) } if has_geo_region_options?
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
    json.nested do
      json.path path

      json.query do
        json.bool do
          json.must do |must_json|
            terms.each do |term|
              must_json.child! { must_json.match { must_json.set! path+'.'+term,  instance_variable_get("@#{term}") } } if instance_variable_get("@#{term}") 
            end
          end
        end
      end

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
    || has_topic_options? || has_geo_region_options?
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
