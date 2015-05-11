class SharepointTradeArticleQuery < Query
  MULTI_VALUE_TERMS = [
    :export_phases, :industries, :trade_regions, :trade_programs, :trade_initiatives,
    :countries, :topics, :sub_topics, :geo_regions, :geo_subregions
  ]

  def initialize(options)
    super
    @q = options[:q].downcase if options[:q].present?
    @creation_date = options[:creation_date] if options[:creation_date].present?
    @release_date = options[:release_date] if options[:release_date].present?
    @expiration_date = options[:expiration_date] if options[:expiration_date].present?
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
    @countries || @export_phases || @creation_date || @release_date || @expiration_date ||
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
        filter_terms.each do |term|
          json.child! { json.terms { json.set! term, instance_variable_get("@#{term}") } } if instance_variable_get("@#{term}")
        end
        generate_date_range(json, 'creation_date', @creation_date) if @creation_date
        generate_date_range(json, 'release_date', @release_date) if @release_date
        generate_date_range(json, 'expiration_date', @expiration_date) if @expiration_date
      end
    end
  end
end
