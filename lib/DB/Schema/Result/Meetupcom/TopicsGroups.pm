package DB::Schema::Result::Meetupcom::TopicsGroups;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('meetupcom.topics_groups');
__PACKAGE__->add_columns(qw/
	id_group
	, id_topic
/);

__PACKAGE__->set_primary_key(qw/id_group id_topic/);

__PACKAGE__->belongs_to(
	'groups' => 'DB::Schema::Result::Meetupcom::Groups'
	, 'id_group'
);
__PACKAGE__->belongs_to(
	'topics' => 'DB::Schema::Result::Meetupcom::Topics'
	, 'id_topic'
);
