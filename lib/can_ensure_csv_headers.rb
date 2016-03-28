module CanEnsureCsvHeaders
  def self.included(base)
    base.class_eval do
      class << self
        attr_accessor :expected_csv_headers
      end
    end
  end

  private

  def ensure_expected_headers(row)
    received_keys = row.to_hash.keys.compact.sort
    if received_keys != self.class.expected_csv_headers.sort
      missing = missing_keys(received_keys).join(',')
      unrecognized = unrecognized_keys(received_keys).join(',')
      message = "CSV key names in source for #{self.class} are not as expected."
      message += " Missing keys: #{missing}." if missing.present?
      message += " Unrecognized keys: #{unrecognized}." if unrecognized.present?
      Rails.logger.error(message)
      raise message
    end
  end

  def unrecognized_keys(received_keys)
    expected = self.class.expected_csv_headers
    received_keys.select { |k| !expected.include?(k) }
  end

  def missing_keys(received_keys)
    expected = self.class.expected_csv_headers
    expected.select { |k| !received_keys.include?(k) }
  end
end
