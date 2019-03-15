class Metadata
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :id, :source, :source_last_updated, :last_imported, :version, :import_rate

  def attributes
    {
      'id' => nil,
      'import_rate' => nil,
      'source' => nil,
      'source_last_updated' => nil,
      'last_imported' => nil,
      'version' => nil
    }
  end

  def to_hash(options = nil)
    serializable_hash options
  end
end
