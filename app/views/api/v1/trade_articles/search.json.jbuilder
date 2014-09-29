json.call(@search, :total)
json.results do
  json.array! @search[:hits] do |hit|
    trade_article = hit.deep_symbolize_keys
    json.id trade_article[:_id]
    json.call(trade_article[:_source],
              :content,
              :pub_date,
              :title,
              :update_date,
              :evergreen,
              :content_type,
              :export_phase,
              :industry,
              :topic,
              :subtopic,
              :trade_region,
              :geo_region,
              :geo_subregion,
              :country,
              :keyword,
       )
  end
end
