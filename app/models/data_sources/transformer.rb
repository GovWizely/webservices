module DataSources
  class Transformer
    def initialize(metadata)
      @transformations = []
      @default = metadata[:default]
      metadata[:transformations].each do |transformation_entry|
        case transformation_entry
          when String
            @transformations << StringTransformation.new(transformation_entry)
          when Hash
            array = transformation_entry.to_a.flatten
            @transformations << StringTransformation.new(array.first, array.from(1))
        end
      end if metadata[:transformations].present?
    end

    def transform(value)
      return @default if value.blank?
      @transformations.inject(value) { |memo, transformation| transformation.transform(memo) }
    end
  end
end
