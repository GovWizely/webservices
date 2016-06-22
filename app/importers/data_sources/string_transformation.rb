module DataSources
  class StringTransformation
    SUPPORTED_INSTANCE_METHODS = %i(downcase first from gsub last strip_tags sub titleize upcase split squish)

    def initialize(method, args = nil)
      @method = method
      @args = args
      raise ArgumentError unless SUPPORTED_INSTANCE_METHODS.include?(@method.to_sym)
    end

    def transform(value)
      @args.present? ? value.send(@method, *@args) : value.send(@method)
    end
  end
end
