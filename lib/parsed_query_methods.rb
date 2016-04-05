module ParsedQueryMethods
  def update_instance_variables(parsed_query)
    @parsed_q = parsed_query[:parsed_q]
    parsed_query[:terms].each do |term|
      if term[:type].include?('Countries')
        @country_names = @country_names.nil? ? [term[:label]] : @country_names.push(term[:label])
      elsif term[:type].include?('World Regions')
        @parsed_world_regions = @parsed_world_regions.nil? ? [term[:label]] : @parsed_world_regions.push(term[:label])
      end
    end
  end

  def generate_parsed_query(json, country_name_field)
    json.query do
      json.bool do
        json.set! 'should' do
          json.child! { generate_multi_match(json, self.class::MULTI_FIELDS, @q) }
          generate_parsed_bool_child(json, country_name_field)
        end
      end if @q
    end
  end

  def generate_parsed_bool_child(json, country_name_field)
    json.child! do
      json.bool do
        json.must do
          generate_parsed_children(json, country_name_field)
        end
      end
    end if @parsed_q && @parsed_q != @q
  end

  def generate_parsed_children(json, country_name_field)
    json.child! { generate_multi_match(json, self.class::MULTI_FIELDS, @parsed_q) } unless @parsed_q.blank?
    json.child! { json.match { json.set! country_name_field, @country_names.join(' ') } } if @country_names
    json.child! { json.terms { json.world_regions @parsed_world_regions } } if @parsed_world_regions
  end
end
