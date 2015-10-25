class Array
  def uniq_push!(element)
    push(element) unless include?(element)
  end
end
