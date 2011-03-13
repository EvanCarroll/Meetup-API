package DB::Schema::Result::Meetupcom::Topics;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('meetupcom.topics');
__PACKAGE__->add_columns(qw/
	id_topic
	topic_urlkey
	topic_name
/);

__PACKAGE__->has_many(
	'_members' => 'DB::Schema::Result::Meetupcom::TopicsMembers'
	, { 'foreign.id_topic' => 'self.id_topic' }
);

__PACKAGE__->many_to_many(
	'members' => '_members' , 'id_member'
);

__PACKAGE__->has_many(
	'lgroups' => 'DB::Schema::Result::Meetupcom::TopicsGroups'
	, { 'foreign.id_topic' => 'self.id_topic' }
);

__PACKAGE__->many_to_many(
	'groups' => 'lgroups' , 'id_group'
);

__PACKAGE__->set_primary_key('id_topic');
