module ScreeningList
  module MakeNameVariants
    include ::FuzzyNameStops

    def make_names(doc)
      doc[:name_idx] = strip(doc[:name], 'punct')
      doc[:name_idx] = filter_words(doc[:name_idx], STOPWORDS)

      make_names_with_common(doc, 'name') unless (doc[:name_idx].downcase.split & COMMON_WORDS).empty?

      doc[:name_rev]       = name_rev(doc[:name_idx])
      doc[:name_no_ws]     = strip(doc[:name_idx], 'whitespace')
      doc[:name_no_ws_rev] = strip(doc[:name_rev], 'whitespace')

      make_alt_names(doc) if doc[:alt_names].present?
    end

    def make_alt_names(doc)
      doc[:alt_idx] = strip(doc[:alt_names], 'punct')
      doc[:alt_idx] = filter_words(doc[:alt_idx], STOPWORDS)

      make_names_with_common(doc, 'alt') unless (doc[:alt_idx].map(&:downcase).join(' ').split & COMMON_WORDS).empty?

      doc[:alt_rev]       = name_rev(doc[:alt_idx])
      doc[:alt_no_ws]     = strip(doc[:alt_idx], 'whitespace')
      doc[:alt_no_ws_rev] = strip(doc[:alt_rev], 'whitespace')
    end

    def make_names_with_common(doc, prefix)
      doc[:"#{prefix}_no_ws_with_common"]     = strip(doc[:"#{prefix}_idx"], 'whitespace')
      doc[:"#{prefix}_no_ws_rev_with_common"] = strip(name_rev(doc[:"#{prefix}_idx"]), 'whitespace')
      doc[:"#{prefix}_idx"]                   = filter_words(doc[:"#{prefix}_idx"], COMMON_WORDS)
    end

    def strip(name, target)
      pattern = target == 'punct' ? /[^\p{Alnum}\p{Space}]/ : /\s+/
      name.class == String ? name.gsub(pattern, '') : name.map { |n| n.gsub(pattern, '') }
    end

    def filter_words(name, wordlist)
      name.class == String ? name.split.delete_if { |n| wordlist.include?(n.downcase) }.join(' ') : name.map { |n| n.split.delete_if { |word| wordlist.include?(word.downcase) }.join(' ') }
    end

    def name_rev(name)
      name.class == String ? name.split.reverse.join(' ') : name.map { |n| n.split.reverse.join(' ') }
    end
  end
end
