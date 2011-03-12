use strict;
$|++;
use warnings;
use feature ':5.10';
use LWP::Simple;
use JSON::XS qw(decode_json);
use Encode;
use URI;
use Getopt::Long;
use DBD::Pg;

my ( $api_key, $group_id );
GetOptions(
	'api_key=s' => \$api_key
	, 'group=i' => \$group_id
);

my $dbh = DBI->connect('dbi:Pg:dbname=meetup');
my $sth = $dbh->prepare(
	'INSERT INTO members (

		id_group
		, id_meetup_member
		, alias
		, country
		, state

		, city
		, zip
		, lat
		, long
		, date_join

		, date_visit
		, l_facebook
		, l_linkedin
		, l_flickr
		, l_twitter

		, bio
		, picture_url
	)
	VALUES (
		?, ?, ?, ?, ?
		, ?, ?, ?, ?, ?
		, ?, ?, ?, ?, ?
		, ?, ?
	)
	'
);

my $uri = URI->new('https://api.meetup.com/members.json/');
$uri->query_form(
	group_id => $group_id
	, key => $api_key
	, order => 'name'
	, format => 'json'
	, page => 200
	, offset => 0
);

my $json;
my $count;
do {
	warn "Retreiving url $uri";
	my $file = get( $uri ) or die "Couldn't fetch";
	use XXX;
	Encode::from_to($file, 'iso-8859-1', 'utf8');
	$json = decode_json( $file );

	foreach my $u ( @{$json->{results}} ) {
		
		$sth->execute(
			$group_id
			, $u->{id}
			, $u->{name}
			, $u->{country}
			, $u->{state}
			, $u->{city}
			, (
				DBI::looks_like_number($u->{zip})
				? $u->{zip}
				: undef
			) # meetup3 seriously wtf
			, $u->{lat}
			, $u->{lon}
			, $u->{joined}
			, $u->{visited}
			, $u->{other_services}{facebook}{identifier}
			, $u->{other_services}{linkedin}{identifier}
			, $u->{other_services}{flickr}{identifier}
			, $u->{other_services}{twitter}{identifier}
			, $u->{bio}
			, $u->{photo_url}
		);
		
		die $dbh->errstr if $dbh->err;
	}

} while (
	$uri = $json->{meta}{'next'}
	and @{ $json->{results} }
);

say "Done!";
