module DataSources
  class SanitizeTransformation
    include HTMLEntityUtils

    def initialize(flavor)
      @flavor = flavor
    end

    def transform(value)
      sanitize_value(value, @flavor)
    end
  end
end
