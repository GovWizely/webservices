module ScreeningList
  module GenerateSort
    SORTABLE_FIELDS = %w(name start_date end_date expiration_date issue_date)

    def generate_sort(sort_param)
      default_sort = ['name.keyword']

      if @q || @name || @address
        @sort = []
      elsif sort_param
        @sort = parse_sort_parameter(sort_param)
        @sort = @sort.empty? ? default_sort : @sort
      else
        @sort = default_sort
      end
    end

    def parse_sort_parameter(value)
      array = split_to_array(value.strip)
      array.map! do |value|
        field_name, _sort_order = value.split(':')
        expand_sortable_field(value) if SORTABLE_FIELDS.include?(field_name)
      end.compact
    end

    def expand_sortable_field(value)
      if value.include?('name')
        value.gsub!('name', 'name.keyword')
      elsif value.include?('expiration_date') || value.include?('issue_date')
        value = 'ids.' + value
      end
      value
    end
  end
end
