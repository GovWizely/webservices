module TradeLead
  module McaImporter
    module McaCountryData
      def extract_iso2_code(mca_country_string)
        mca_country_string.match(/country\/(\w\w)/)[1].upcase
      end

      def extract_country_name(mca_country_string)
        mca_country_string.match(/- ([a-zA-Z ]+)/)[1]
      end
    end
  end
end