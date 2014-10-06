json.id entry[:_id]
json.call(entry[:_source],
	:title, :short_title, :summary, :creation_date, :release_date, :expiration_date, :source_agencies, :evergreen, :content,
	:keyword, :ita_tags, :seo_metadata_title, :seo_metadata_description, :seo_metadata_keyword,
	:trade_url, :file_url, :image_url, :url_html_source, :url_xml_source
)
