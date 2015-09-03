module ScreeningList
  module MakeAddressVariants
    STOPWORDS    = %w( and the los )
    COMMON_WORDS = %w( box st ave )

    def make_addresses(doc)

      addr = doc[:addresses][0][:address]
      doc[:address_idx] = strip(addr, 'punct')
      doc[:address_idx] = filter_words(doc[:address_idx], STOPWORDS)

      make_addresses_with_common(doc) unless (doc[:address_idx].downcase.split & COMMON_WORDS).empty?

      doc[:address_rev]       = address_rev(doc[:address_idx])
      doc[:address_no_ws]     = strip(doc[:address_idx], 'whitespace')
      doc[:address_no_ws_rev] = strip(doc[:address_rev], 'whitespace')
    end

    def make_addresses_with_common(doc)
      doc[:address_no_ws_with_common]     = strip(doc[:address_idx], 'whitespace')
      doc[:address_no_ws_rev_with_common] = strip(address_rev(doc[:address_idx]), 'whitespace')
      doc[:address_idx]                   = filter_words(doc[:address_idx], COMMON_WORDS)
    end

    def strip(address, target)
      pattern = target == 'punct' ? /[\]\[!"#$%&()*+,.:;<=>?@^_`{|}\/~]/ : /\s+/
      address.class == String ? address.gsub(pattern, '') : address.map { |n| n.gsub(pattern, '') }
    end

    def filter_words(address, wordlist)
      address.class == String ? address.split.delete_if { |n| wordlist.include?(n.downcase) }.join(' ') : address.map { |n| n.split.delete_if { |word| wordlist.include?(word.downcase) }.join(' ') }
    end

    def address_rev(address)
      address.class == String ? address.split.reverse.join(' ') : address.map { |n| n.split.reverse.join(' ') }
    end
  end
end
