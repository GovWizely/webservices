json.call(entry[:_source],
          :country, :title, :reference_number, :contract_number, :publish_date, :end_date,
          :publish_date_amended, :status, :industry,
          :specific_location, :notice_type, :trade_agreement, :bid_type,
          :competitive_procurement_strategy, :non_competitive_procurement_strategy,
          :procurement_organization, :implementing_entity, :description, :contact, :urls)
