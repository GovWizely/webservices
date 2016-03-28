# For shared methods used by the two FBO importers
module TradeLead
  module FbopenHelpers
    def process_geo_fields(entry)
      entry[:country] = begin
                          IsoCountryCodes.find(entry[:country]).alpha2
                        rescue
                          nil
                        end
      entry[:country_name] = begin
                               IsoCountryCodes.find(entry[:country]).name
                             rescue
                               nil
                             end
      entry.merge! add_related_fields([entry[:country_name]])
    end

    def extract_end_date(entry)
      [entry[:arch_date], entry[:resp_date]].reject(&:nil?).max
    end
  end
end
