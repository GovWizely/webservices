module DataSources
  class StringTransformation
    SUPPORTED_INSTANCE_METHODS = %i(downcase first from gsub last reformat_date strip_tags sub titleize upcase)

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
