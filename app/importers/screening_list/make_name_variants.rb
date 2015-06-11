module ScreeningList
  module MakeNameVariants
    ##
    # index 2 forms of each name for both "name" and "alt_names" (if applicable),
    # one with punctuation and "stopwords" removed and
    # one the above plus "common" words removed.
    #
    # then store additional modified versions of the two in the following ways:
    #
    #     1) reversed
    #     2) with white space removed
    #     3) reversed with white space removed
    #

    def make_names(doc)
      stopwords    = %w( and the los )
      common_words = %w( co company corp corporation inc incorporated limited ltd mr mrs ms organization sa sas llc )

      doc[:name_idx]      = doc[:name].gsub(/[[:punct:]]/, '')
      doc[:name_idx]      = doc[:name_idx].split.delete_if { |name| stopwords.include?(name.downcase) }.join(' ')

      # if there is a common word, make entries to index
      unless (doc[:name_idx].downcase.split & common_words).empty?
        doc[:name_with_common]          = doc[:name_idx]
        doc[:rev_name_with_common]      = doc[:name_with_common].split.reverse.join(' ')
        doc[:trim_name_with_common]     = doc[:name_with_common].gsub(/\s+/, '')
        doc[:trim_rev_name_with_common] = doc[:rev_name_with_common].gsub(/\s+/, '')
        doc[:name_idx]                  = doc[:name_idx].split.delete_if { |name| common_words.include?(name.downcase) }.join(' ')
      end

      doc[:rev_name]      = doc[:name_idx].split.reverse.join(' ')
      doc[:trim_name]     = doc[:name_idx].gsub(/\s+/, '')
      doc[:trim_rev_name] = doc[:rev_name].gsub(/\s+/, '')

      if doc[:alt_names].present?

        doc[:alt_names_idx]      = doc[:alt_names].map { |name| name.gsub(/[[:punct:]]/, '') }
        doc[:alt_names_idx]      = doc[:alt_names_idx].map { |name| name.split.delete_if { |word| stopwords.include?(word.downcase) }.join(' ') }

        # if there is a common word, make entries to index
        unless (doc[:alt_names_idx].map(&:downcase).join(' ').split & common_words).empty?
          doc[:alt_names_with_common]    = doc[:alt_names_idx]
          doc[:rev_alt_with_common]      = doc[:alt_names_with_common]
          doc[:trim_alt_with_common]     = doc[:alt_names_with_common].map { |name| name.gsub(/\s+/, '') }
          doc[:trim_rev_alt_with_common] = doc[:rev_alt_with_common].map { |name| name.gsub(/\s+/, '') }
          doc[:alt_names_idx]            = doc[:alt_names_idx].map { |name| name.split.delete_if { |word| common_words.include?(word.downcase) }.join(' ') }
        end

        doc[:rev_alt_names]      = doc[:alt_names_idx].map { |name| name.split.reverse.join(' ') }
        doc[:trim_alt_names]     = doc[:alt_names_idx].map { |name| name.gsub(/\s+/, '') }
        doc[:trim_rev_alt_names] = doc[:rev_alt_names].map { |name| name.gsub(/\s+/, '') }
      end
      doc
    end
  end
end
