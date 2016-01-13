module DataSources
  class SVIngester < Ingester
    def initialize(klass, metadata, data, col_sep)
      super(klass, metadata, data)
      @col_sep = col_sep
    end

    def ingest
      ingest_sv_options = { converters:        [->(f) { f ? f.squish : nil }, :date, :numeric],
                            header_converters: [->(f) { convert_header(f) }],
                            headers:           true,
                            col_sep:           @col_sep,
                            skip_blanks:       true }
      records = CSV.parse(@data, ingest_sv_options).map { |r| r }
      insert(records)
    end

    private

    def convert_header(source)
      @metadata.entries.detect { |_, meta| meta[:source] == source }.first rescue '*DELETED FIELD*'
    end
  end
end
