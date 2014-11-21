class SharepointTradeArticleQuery < Query
  SINGLE_VALUE_TERMS = [
    :creation_date_start, :creation_date_end,
    :release_date_start, :release_date_end, :expiration_date_start, :expiration_date_end, :q
  ]

  MULTI_VALUE_TERMS = [
    :export_phases, :industries, :trade_regions, :trade_programs, :trade_initiatives,
    :countries, :topics, :sub_topics, :geo_regions, :geo_subregions
  ]

  def initialize(options)
    super
    SINGLE_VALUE_TERMS.each do |term|
      instance_variable_set("@#{term}", options[term].downcase) if options[term].present?
    end
    MULTI_VALUE_TERMS.each do |term|
      instance_variable_set("@#{term}", options[term].downcase.split(',')) if options[term].present?
    end
  end

  def generate_query(json)
    q_terms = %w(title short_title summary content keyword)
    json.query do
      generate_sp_query(q_terms, json)
    end if @q
  end

  def generate_filter(json)
    json.filter do
      generate_sp_filter(json, MULTI_VALUE_TERMS)
    end if has_filter_options?
  end

  private

  def has_filter_options?
    @creation_date_start || @creation_date_end || @release_date_start || @release_date_end ||
    @expiration_date_start || @expiration_date_end || @countries || @export_phases ||
    @industries || @trade_regions || @trade_programs || @trade_initiatives ||
    @topics || @sub_topics || @geo_regions || @geo_subregions
  end

  def generate_sp_query(q_terms, json)
    json.bool do
      json.must do |_must_json|
        json.child! { generate_multi_match(json, q_terms, @q) } if @q
      end
    end
  end

  def generate_sp_filter(json, filter_terms)
    json.bool do
      json.must do
        generate_date_range(json, 'creation_date')
        generate_date_range(json, 'release_date')
        generate_date_range(json, 'expiration_date')
        filter_terms.each do |term|
          json.child! { json.terms { json.set! term, instance_variable_get("@#{term}") } } if instance_variable_get("@#{term}")
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
end
