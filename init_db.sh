#!/bin/sh

echo "Re-initializing DB";

cat <<-'EOF' | psql -d meetup
	DROP TABLE members;
	CREATE TABLE members (
		id_group            int
		, id_meetup_member  int
		, alias             text
		, country           text
		, state             text
		, city              text
		, zip               int
		, lat               float8
		, long              float8
		, date_join         timestamp
		, date_visit        timestamp
		, l_facebook        text
		, l_linkedin        text
		, l_flickr          text
		, l_twitter         text
		, bio               text
		, picture_url       text
		, PRIMARY KEY ( id_group, id_meetup_member )
	);
	CREATE OR REPLACE FUNCTION meetup_profile_url ( text, text ) RETURNS text AS $$
		SELECT 'http://www.meetup.com/'
			|| CASE WHEN $2 IS NOT NULL THEN $2::text || '/' ELSE '' END
			|| 'members/'
			|| $1
		;
	$$ LANGUAGE sql;
EOF

