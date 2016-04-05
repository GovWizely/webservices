module Elasticsearch
  module Model
    # Keeps a global registry of classes that include `Elasticsearch::Model`
    #
    class Registry
      # Upserts a model in the registry
      #
      def self.upsert(klass)
        __instance.upsert(klass)
      end

      def upsert(klass)
        @models.delete klass
        @models << klass
      end
    end
  end
end
