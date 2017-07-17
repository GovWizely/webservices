module FuzzyNameStops
  STOPWORDS    = %w(and the los)
  COMMON_WORDS = %w(co company corp corporation inc incorporated limited ltd mr mrs ms organization sa sas llc university univ)

  def remove_stops(name)
    name = name.gsub(/[^\p{Alnum}\p{Space}]/, '')
    name = name.split.delete_if { |n| STOPWORDS.include?(n.downcase) }.join(' ')
    name = name.split.delete_if { |n| COMMON_WORDS.include?(n.downcase) }.join(' ')
    name
  end
end
