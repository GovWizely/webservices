module Model
  module CanDeleteOldDocuments
    def self.extended(base)
      ensure_extended_by_indexable(base)

      base.mappings = {
        base.to_s.typeize => {
          '_timestamp' => {
            'enabled' => true,
            'store'   => true,
          },
        },
      }
    end

    def delete_old_documents(before_time)
      body = {
        query: {
          filtered: {
            filter: {
              range: {
                _timestamp: {
                  lt: (before_time.to_f * 1000.0).to_i,
                },
              },
            },
          },
        },
      }

      ES.client.delete_by_query(index: index_name, body: body)
    end

    def self.ensure_extended_by_indexable(base)
      extended_by_indexable =
        base.singleton_class.included_modules.find { |a| a.name == 'Indexable' }
      unless extended_by_indexable
        fail "#{base.name} must be extended by Indexable"
      end
    end
  end
end
