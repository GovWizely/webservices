module Utils
  module_function

  def generate_id(hash = {}, keys = [])
    Digest::SHA1.hexdigest(keys.map { |k| hash[k] }.join)
  end
end
