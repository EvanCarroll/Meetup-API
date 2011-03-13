CREATE TABLE meetupcom.members (
	id_member           int            UNIQUE
	, id_group          int            REFERENCES meetupcom.groups
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
	, PRIMARY KEY ( id_member, id_group )
);
