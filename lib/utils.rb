module Utils
  module_function

  def generate_id(hash = {}, keys = [])
    Digest::SHA1.hexdigest(keys.map { |k| hash[k] }.join)
  end

  def older_than(timefield, timestamp)
    Jbuilder.new do |json|
      json.query do
        json.constant_score do
          json.filter do
            json.range do
              json.set! timefield do
                json.lt timestamp
              end
            end
          end
        end
      end
    end.attributes!
  end
end
