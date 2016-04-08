module Elasticsearch
  module Model
    # Keeps a global registry of classes that include `Elasticsearch::Model`
    #
    class Registry
      # Clears all models from the registry
      #
      def self.clear
        __instance.clear
      end

      def clear
        @models = []
      end
    end
  end
end
