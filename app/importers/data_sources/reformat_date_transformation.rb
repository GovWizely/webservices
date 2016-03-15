module DataSources
  class ReformatDateTransformation

    def initialize(date_format)
      @date_format = date_format
    end

    def transform(value)
      Date.strptime(value, @date_format).to_s
    end

  end
end
