CREATE TABLE meetupcom.groups (
	id_group       int        PRIMARY KEY
	, group_alias  text
	, members      int
	, description  text
	, state        text
	, city         text
	, lat          float8
	, long         float8
	, organizer_id int
	, date_created timestamp
	, date_updated timestamp
	, is_private   bool
);
