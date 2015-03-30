class RecreateIndicesWithModifiedMappings
  class << self
    def call
      model_classes_which_need_recreating.each do |model_class|
        Rails.logger.info("Recreating index and importing #{model_class}")
        model_class.recreate_index
        model_class.importer_class.new.import_and_if_possible_purge_old
      end
    end

    def model_classes_which_need_recreating
      Webservices::Application.model_classes.sort do |a, b|
        if a.name.include?('TariffRate') && !b.name.include?('TariffRate')
          1
        elsif b.name.include?('TariffRate') && !a.name.include?('TariffRate')
          -1
        else
          0
        end
      end.select do |model_class|
        index = model_class.index_name

        model_mapping = model_class.mappings
        db_mapping = ES.client.indices.get_mapping(index: index)[index]['mappings']

        !same?(model_mapping.deep_stringify, db_mapping.deep_stringify)
      end
    end

    # Due to the fact that in ES you don't have to explicitly define mappings for
    # every field that a document may have, we cannot just do a straight-up "=="
    # comparison here. ES may add property mappings for fields that don't have a
    # mapping in our model (they'll be "dynamic mappings" in ES speak).
    #
    # So our strategy is to recursively examine keys from the mapping as defined
    # in our model, comparing them to their counterparts in the DB mapping. We're
    # assuming that if a key exists in the DB but not in the model, it has been
    # automatically (and correctly) added by ES.
    #
    # This doesn't guarantee that the DB vs. model mappings are going to produce
    # the same behavior, but it does tell us if a mapping *as defined in our
    # model* is different from how it is defined in the DB, which is what we're
    # looking for.
    def same?(model_entity, db_entity)
      return false if model_entity.class != db_entity.class

      if model_entity.is_a?(Hash)
        model_entity.each do |k, v|
          return false unless same?(v, db_entity[k])
        end
        return true
      else
        return model_entity == db_entity
      end
    end
  end
end
