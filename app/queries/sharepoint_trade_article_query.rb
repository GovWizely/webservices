class SharepointTradeArticleQuery < Query
  include SharepointHelpers
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
      generate_sp_query(terms, q_terms, json)
    end if has_query_options?
  end

  def generate_filter(json)
    json.filter do
      generate_sp_filter(json)
    end if has_filter_options?
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
