CREATE OR REPLACE FUNCTION meetupcom.meetup_profile_url ( text, text ) RETURNS text AS $$
	SELECT 'http://www.meetup.com/'
		|| CASE WHEN $2 IS NOT NULL THEN $2::text || '/' ELSE '' END
		|| 'members/'
		|| $1
	;
$$ LANGUAGE sql;
