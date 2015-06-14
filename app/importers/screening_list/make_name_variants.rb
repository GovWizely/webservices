module ScreeningList
  module MakeNameVariants
    ##
    # index 2 forms of each name for both "name" and "alt_names" (if applicable),
    # one with punctuation and "STOPWORDS" removed and
    # one the above plus "common" words removed.
    #
    # then store additional modified versions of the two in the following ways:
    #
    #     1) reversed
    #     2) with white space removed
    #     3) reversed with white space removed
    #

    STOPWORDS    = %w( and the los )
    COMMON_WORDS = %w( co company corp corporation inc incorporated limited ltd mr mrs ms organization sa sas llc )

    def make_names(doc)
      doc[:name_idx] = strip_punct(doc[:name])
      doc[:name_idx] = filter_words(doc[:name_idx], STOPWORDS)

      make_names_with_common(doc, 'name') unless (doc[:name_idx].downcase.split & COMMON_WORDS).empty?

      doc[:name_rev]      = name_rev(doc[:name_idx])
      doc[:name_trim]     = name_trim(doc[:name_idx])
      doc[:name_trim_rev] = name_trim(doc[:name_rev])

      make_alt_names(doc) if doc[:alt_names].present?
    end

    def make_alt_names(doc)
      doc[:alt_idx] = strip_punct(doc[:alt_names])
      doc[:alt_idx] = filter_words(doc[:alt_idx], STOPWORDS)

      make_names_with_common(doc, 'alt') unless (doc[:alt_idx].map(&:downcase).join(' ').split & COMMON_WORDS).empty?

      doc[:alt_rev]      = name_rev(doc[:alt_idx])
      doc[:alt_trim]     = name_trim(doc[:alt_idx])
      doc[:alt_trim_rev] = name_trim(doc[:alt_rev])
    end

    def make_names_with_common(doc, prefix)
      doc[:"#{prefix}_with_common"]          = doc[:"#{prefix}_idx"]
      doc[:"#{prefix}_rev_with_common"]      = name_rev(doc[:"#{prefix}_with_common"])
      doc[:"#{prefix}_trim_with_common"]     = name_trim(doc[:"#{prefix}_with_common"])
      doc[:"#{prefix}_trim_rev_with_common"] = name_trim(doc[:"#{prefix}_rev_with_common"])
      doc[:"#{prefix}_idx"]                  = filter_words(doc[:"#{prefix}_idx"], COMMON_WORDS)
    end

    def strip_punct(name)
      name.class == String ? name.gsub(/[[:punct:]]/, '') : name.map { |n| n.gsub(/[[:punct:]]/, '') }
    end

    def filter_words(name, wordlist)
      name.class == String ? name.split.delete_if { |n| wordlist.include?(n.downcase) }.join(' ') : name.map { |n| n.split.delete_if { |word| wordlist.include?(word.downcase) }.join(' ') }
    end

    def name_rev(name)
      name.class == String ? name.split.reverse.join(' ') : name.map { |n| n.split.reverse.join(' ') }
    end

    def name_trim(name)
      name.class == String ? name.gsub(/\s+/, '') : name.map { |n| n.gsub(/\s+/, '') }
    end
  end
end
