class SharepointTradeArticleQuery < Query
  include SharepointHelpers
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
    terms = []
    q_terms = %w(title short_title summary content keyword)
    json.query do
      generate_sp_query(terms, q_terms, json)
    end if @q
  end

  def generate_filter(json)
    json.filter do
      generate_sp_filter(json, MULTI_VALUE_TERMS)
    end if has_filter_options?
  end

  def has_filter_options?
    @creation_date_start || @creation_date_end || @release_date_start || @release_date_end ||
    @expiration_date_start || @expiration_date_end || @countries || @export_phases ||
    @industries || @trade_regions || @trade_programs || @trade_initiatives ||
    @topics || @sub_topics || @geo_regions || @geo_subregions
  end
end
