module QueryParser
  def parse_query
    taxonomy_search_results = ItaTaxonomy.search_related_terms(q: @q, types: 'Countries,World Regions')

    taxonomy_search_results.each do |result|
      next unless @q.include?(result[:label].downcase)
      @q.slice! result[:label].downcase
      @q = @q.strip
      update_instance_variables(result)
    end
  end

  def update_instance_variables(result)
    if result[:type].include?('Countries')
      @country_names = @country_names.nil? ? [result[:label]] : @country_names.push(result[:label])
    elsif result[:type].include?('World Regions')
      @world_regions = @world_regions.nil? ? [result[:label]] : @world_regions.push(result[:label])
    end
  end
end
