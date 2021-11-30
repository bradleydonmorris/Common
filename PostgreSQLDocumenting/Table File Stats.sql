WITH missing_pk_tables AS
(
    SELECT
		tables.table_schema,
        tables.table_name,
        (
            SELECT MAX(pg_ls_dir::int)::text 
            	FROM pg_ls_dir('./base') 
            	WHERE
					pg_ls_dir <> 'pgsql_tmp' 
            		AND pg_ls_dir::int  <=
					(
						SELECT relfilenode
							FROM pg_class
							WHERE relname ILIKE tables.table_name
					)
        ) AS folder,
		(
			SELECT relfilenode
				FROM pg_class
				WHERE relname ILIKE tables.table_name
		) AS filenode
    FROM information_schema.tables
		INNER JOIN
		(
			VALUES
				('public', 'c3p0_test_table'),
				('public', 't_dummy_city_populator'),
				('public', 't_dummy_city_populator_2'),
				('public', 't_dummy_city_populator_3'),
				('public', 't_dummy_city_populator_4'),
				('public', 't_dummy_city_populator_5'),
				('public', 't_populator_device'),
				('public', 't_populator_landing_signups'),
				('public', 't_populator_person_asset'),
				('public', 't_populator_unscribed'),
				('public', 't_stockimg_ail_colors_populator'),
				('public', 't_stockimg_dir'),
				('public', 't_stockimg_viflist_populator'),
				('public', 't_temp_populate_employee'),
				('public', 't_tsd_cfleet_to_ti_matching'),
				('public', 't_tsd_cnotes_to_ti_matching'),
				('public', 't_tsd_cra001_to_ti_matching'),
				('public', 't_tsd_cradriver_to_ti_matching'),
				('public', 'temp_alternate_location_data'),
				('public', 'temp_counter_location_data'),
				('public', 'temp_country'),
				('public', 'temp_extended_location_data'),
				('public', 'temp_location_code_extended_data'),
				('public', 'temp_main_org_data'),
				('public', 'temp_org_data'),
				('public', 'tmp_rate_item'),
				('public', 'tmp_res_rate_item'),
				('public', 'v_role_id_sunset'),
				('public', 'v_total_amount'),
				('tsd', 't_activity_log_integ_knum'),
				('tsd', 't_adp_email_exceptions'),
				('tsd', 't_adp_email_exceptions_2nd_pass'),
				('tsd', 't_date_dimension'),
				('tsd', 't_deadbeat_matched'),
				('tsd', 't_fox_csod_users'),
				('tsd', 't_fox_tsd_loctaxes_hourly'),
				('tsd', 't_fox_tsd_reservation_web_loyalty'),
				('tsd', 't_fox_tsd_to_xp_cancelled_reservations'),
				('tsd', 't_license_with_expiration_date_matched'),
				('tsd', 't_org_unit_adp_location_id'),
				('tsd', 't_primarydrivers'),
				('tsd', 't_reservation_for_update'),
				('tsd', 't_reservation_for_update_not_converted'),
				('tsd', 't_secondarydrivers'),
				('tsd', 't_service_agent_associate'),
				('tsd', 't_tsd_to_ti_unique_license_for_webloyalty'),
				('tsd', 't_webloyalty_rez_jsi_matched'),
				('tsd', 'temp_adp_ti_update_process_active'),
				('tsd', 'temp_adp_ti_update_process_inactive'),
				('tsd', 'temp_deadbeat_active'),
				('tsd', 'temp_deadbeat_suspended'),
				('tsd', 'temp_tsd_primary'),
				('tsd', 'temp_tsd_primary_address')
		) AS missing_pk_tables(table_schema, table_name)
			ON
				tables.table_schema = missing_pk_tables.table_schema
				and tables.table_name = missing_pk_tables.table_name
)
SELECT
	table_schema,
    table_name,
	file_stats.creation,
	file_stats.access,
	file_stats.modification,
	file_stats.change,
	file_stats.size
	FROM missing_pk_tables
		LEFT JOIN LATERAL
		(
			SELECT creation, access, modification, change, size
				FROM pg_stat_file('./base/' || folder || '/' || filenode)
		) AS file_stats ON true
;