module Webservices
  module ApiModels
    def self.redefine_model_constant(klass_symbol, klass)
      remove_const klass_symbol if constants.include?(klass_symbol)
      const_set(klass_symbol, klass)
    end
  end
end
