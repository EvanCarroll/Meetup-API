package DB::Schema::Result::Meetupcom::Members;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('meetupcom.members');
__PACKAGE__->add_columns(qw/
	id_group
	id_member
	alias
	country
	state
	city
	zip
	lat
	long
	date_join
	date_visit
	l_facebook
	l_linkedin
	l_flickr
	l_twitter
	bio
	picture_url
/);

__PACKAGE__->set_primary_key('id_member');
__PACKAGE__->belongs_to(
	'group' => 'DB::Schema::Result::Meetupcom::Groups'
	, 'id_group'
);

__PACKAGE__->has_many(
	'_topics' => 'DB::Schema::Result::Meetupcom::TopicsMembers'
	, 'id_member'
);

__PACKAGE__->many_to_many(
	'topics' => '_topics'
	, 'topics'
);

1;
