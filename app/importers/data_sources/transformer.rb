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
            process_hash(transformation_entry)
        end
      end if metadata[:transformations].present?
    end

    def transform(value)
      return @default if value.blank?
      @transformations.inject(value) { |memo, transformation| transformation.transform(memo) }
    end

    private

    def process_hash(transformation_entry_hash)
      transformation_klass_name = "DataSources::#{transformation_entry_hash.keys.first.to_s.camelize}Transformation"
      if class_exists?(transformation_klass_name)
        klass = transformation_klass_name.constantize
        @transformations << klass.new(transformation_entry_hash.values.first)
      else
        array = transformation_entry_hash.to_a.flatten
        @transformations << StringTransformation.new(array.first, array.from(1))
      end
    end

    def class_exists?(class_name)
      Module.const_get(class_name).is_a?(Class)
    rescue NameError
      false
    end
  end
end
