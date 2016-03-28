# For shared methods used by the two FBO importers
module TradeLead
  module FbopenHelpers
    def process_geo_fields(entry)
      entry[:country] = begin
                          IsoCountryCodes.find(entry[:country]).alpha2
                        rescue
                          nil
                        end
      entry.merge! add_geo_fields([entry[:country]])
    end

    def extract_end_date(entry)
      [entry[:arch_date], entry[:resp_date]].reject(&:nil?).max
    end
  end
end
