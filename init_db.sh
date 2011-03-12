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
		, join_date    timestamp
		, visit_date   timestamp
		, facebook     text
		, linked_in    text
		, flickr       text
		, bio          text
	)
EOF

