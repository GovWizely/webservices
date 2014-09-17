class FbopenParser::RecTransform < Parslet::Transform
  rule(records: subtree(:records)) do
    records.map do |r|
      ntype = r[:ntype].to_s
      attrs = r[:attrs].reduce({}) do |memo, attr|
        key = attr[:name].to_s
        if memo.key?(key)
          Rails.logger.warn "[FbopenParser::RecTransform] Duplicate key '#{key}' on record: #{r}"
        end
        memo[key] = attr[:value].to_s.strip
        memo
      end
      attrs['ntype'] = ntype
      attrs
    end
  end
end
