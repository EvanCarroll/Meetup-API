#!/bin/sh

echo "Re-initializing DB";

cat <<EOF | psql -d meetup
	DROP TABLE members;
	CREATE TABLE members (
		meetup_id      int          PRIMARY KEY
		, alias        text
		, country      text
		, state        text
		, city         text
		, zip          int
		, lat          float8
		, long         float8
		, date_join    timestamp
		, date_visit   timestamp
		, l_facebook   text
		, l_linkedin   text
		, l_flickr     text
		, bio          text
	);
	CREATE FUNCTION meetup_profile_url ( text, text ) RETURNS text AS $$
		SELECT 'http://www.meetup.com/'
			|| CASE WHEN $2 IS NOT NULL THEN $2::text || '/' ELSE '' END
			|| 'members/'
			|| $1
		;
	$$ LANGUAGE sql;
EOF

