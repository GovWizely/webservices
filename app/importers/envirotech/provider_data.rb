module Envirotech
  class ProviderData < BaseData
    ENDPOINT = 'https://admin.export.gov/admin/envirotech_providers.json'

    COLUMN_HASH = {
      'id'         => :source_id,
      'name'       => :name_english,
      'created_at' => :source_created_at,
      'updated_at' => :source_updated_at,
    }.freeze
  end
end
