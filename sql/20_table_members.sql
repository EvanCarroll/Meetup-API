CREATE TABLE meetupcom.members (
	id_group            int            REFERENCES meetupcom.groups
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
