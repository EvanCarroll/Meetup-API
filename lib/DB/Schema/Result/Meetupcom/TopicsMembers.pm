package DB::Schema::Result::Meetupcom::TopicsMembers;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('meetupcom.topics_members');
__PACKAGE__->add_columns(qw/
	id_member
	, id_topic
/);

__PACKAGE__->set_primary_key(qw/id_member id_topic/);

__PACKAGE__->belongs_to(
	'groups' => 'DB::Schema::Result::Meetupcom::Members'
	, 'id_member'
);
__PACKAGE__->belongs_to(
	'topics' => 'DB::Schema::Result::Meetupcom::Topics'
	, 'id_topic'
);
