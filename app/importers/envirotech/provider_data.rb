module Envirotech
  class ProviderData < Envirotech::BaseData
    ENDPOINT = Rails.root.join('data/envirotech/providers.json').to_s

    COLUMN_HASH = {
      'id'         => :source_id,
      'name'       => :name_english,
      'created_at' => :source_created_at,
      'updated_at' => :source_updated_at,
    }.freeze
  end
end
