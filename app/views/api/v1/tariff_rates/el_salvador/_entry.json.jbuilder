json.call(entry[:_source],
          :source_id, :tariff_line, :description, :hs_6, :sector_code, :base_rate,
          :base_rate_alt, :final_year, :tariff_lines_per_6_digit, :tariff_rate_quota, :tariff_rate_quota_note,
          :tariff_eliminated, :product_type_id, :pending_data, :ag_id, :partner_name,
          :reporter_name, :staging_basket, :staging_basket_id, :num_mar_columns,
          :partner_start_year, :reporter_start_year, :partner_agreement_name,
          :reporter_agreement_name, :partner_agreement_approved,
          :reporter_agreement_approved, :rule_text, :link_text, :link_url,
          :quota_name, :industry, :annual_rates, :alt_annual_rates, :countries, :source
)
