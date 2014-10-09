module ScreeningList
  module CanGroupRows
    def self.included(base)
      base.class_eval do
        class << self
          attr_accessor :group_by
        end
      end
    end

    def group_by
      self.class.group_by
    end

    def group_rows(rows)
      grouped_rows = {}
      rows.each do |row|
        id = generate_id(row)
        grouped_rows[id] ||= []
        grouped_rows[id] << row
      end
      grouped_rows
    end

    def generate_id(row)
      Digest::SHA1.hexdigest(group_by.map { |f| row[f] }.join)
    end
  end
end
