CREATE TABLE meetupcom.topics_members (
	id_member  int     REFERENCES meetupcom.members(id_member)
	, id_topic int     REFERENCES meetupcom.topics
	, PRIMARY KEY ( id_member, id_topic )
);
