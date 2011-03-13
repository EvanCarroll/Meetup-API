package DB::Schema::Result::Meetupcom::Groups;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('meetupcom.groups');
__PACKAGE__->add_columns(qw/
	id_group
	group_alias
	members
	description
	state
	city
	zip
	lat
	long
	organizer_id
	date_created
	date_updated
	is_private
/);

__PACKAGE__->set_primary_key('id_group');
__PACKAGE__->has_many(
	'members' => 'DB::Schema::Result::Meetupcom::Members'
	, 'id_group'
);

__PACKAGE__->has_many(
	'_topics' => 'DB::Schema::Result::Meetupcom::TopicsGroups'
	, 'id_group'
);

__PACKAGE__->many_to_many(
	'topics' => '_topics'
	, 'topics'
);

1;
