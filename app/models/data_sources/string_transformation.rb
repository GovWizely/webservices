module DataSources
  class StringTransformation
    SUPPORTED_INSTANCE_METHODS = %i(upcase downcase titleize from first last sub gsub strip_tags)

    def initialize(method, args = nil)
      @method = method
      @args = args
      fail ArgumentError unless SUPPORTED_INSTANCE_METHODS.include?(@method.to_sym)
    end

    def transform(value)
      @args.present? ? value.send(@method, *@args) : value.send(@method)
    end
  end
end
