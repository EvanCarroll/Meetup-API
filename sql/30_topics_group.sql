CREATE TABLE meetupcom.topics_groups (
	id_group   int  REFERENCES meetupcom.groups
	, id_topic int  REFERENCES meetupcom.topics
	, PRIMARY KEY ( id_group, id_topic )
);
