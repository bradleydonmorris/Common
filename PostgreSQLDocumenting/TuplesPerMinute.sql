select 
	relname,
	reltuples,
	round(reltuples/1440) tuples_per_minute
	from pg_class
	where 
		pg_class.relkind = 'r'
		and pg_class.relname like 't_process_request_response_p%'
;
	
